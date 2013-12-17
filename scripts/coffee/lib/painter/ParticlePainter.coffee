FloatStruct = require '../utility/FloatStruct'
_Painter = require '../_Painter'
shaders = require './ParticlePainter/shaders'

module.exports = class ParticlePainter extends _Painter

	self = @

	_setupDataStructure: ->

		@_baseParams = {}

		flags = @flags

		@_struct = new FloatStruct

		@_struct.float 'size', 1, [1]

		@_struct.float 'pos', 3

		@_struct.float 'opacity', 1, [1]

		@_struct.short 'enabled', 1, [1]

		if flags.tint

			@_struct.float 'tint', 4

		switch flags.blending

			when no

				@_blendingMode = 0

			when yes

				@_blendingMode = 1

			when 'transparent'

				@_blendingMode = 1

			when 'add'

				@_blendingMode = 2

			else

				@_blendingMode = 0

		if flags.fillWithImage

			# These will be set in the element api
			@_baseParams.fillWithImageProps = image: null, updated: no

			# The attribute to the coordinates of the image in the atlas
			@_struct.float 'fillWithImageCoords', 4

			# We should enable the atlas
			@_uniforms.imageAtlasSlot = @_program.uniform '1i', 'imageAtlasSlot'

		else if flags.maskOnImage

			# These will be set in the element api
			@_baseParams.maskOnImageProps = image: null, updated: no

			# The attribute to the coordinates of the image in the atlas
			@_struct.float 'maskOnImageCoords', 4

			# We should enable the atlas
			@_uniforms.pictureAtlasSlot = @_program.uniform '1i', 'pictureAtlasSlot'

		else

			@_struct.unsignedByte 'color', 4, [255, 255, 255, 255], yes

		if flags.maskWithImage

			# These will be set in the element api
			@_baseParams.maskWithImageProps = image: null, updated: no, channel: 0

			# The attribute to the coordinates of the image in the atlas
			@_struct.float 'maskWithImageCoords', 4

			# The attribute to specify which color channel should be used for the mask
			@_struct.float 'maskWithImageChannel', 1

			# We should enable the atlas
			@_uniforms.imageAtlasSlot = @_program.uniform '1i', 'imageAtlasSlot'

	makeParamHolder: ->

		@_struct.makeParamHolder @_baseParams

	makeParamHolders: (count) ->

		@_struct.makeParamHolders @_baseParams, count

	_init: (scene, @flags, @index) ->

		@_currentBlending = -1

		@_program = do @_getProgram

		@_program.activate()

		@_uniforms =

			win: @_program.uniform('2f', 'win')
			.set(@_scene._dims.perceivedWidth, @_scene._dims.perceivedHeight)

		@_imageAtlasTexture = null

		do @_setupDataStructure

		@_theBuffer = @_gila.makeArrayBuffer()

		do @_setupAttribs

	_getProgram: ->

		flagsInCaps = {}

		for key, val of @flags

			flagsInCaps[key.toUpperCase()] = val

		vert = @_gila.getVertexShader 'particle-shader-vert',

			shaders.vert, flagsInCaps

		frag = @_gila.getFragmentShader 'particle-shader-frag',

			shaders.frag, flagsInCaps

		@_gila.getProgram vert, frag

	_setupAttribs: ->

		@_program.activate()

		@_theBuffer.bind()

		stride = @_struct.getStride()

		for el in @_struct.getElements()

			@_program.attr(el.name).enable()._pointer el.size,

				el.glType, el.normalized, stride, el.offset

		return

	_prepareImageAtlasTexture: (imageUrl) ->

		return if @_imageAtlasTexture?

		@_imageAtlasTexture = @_scene._textureRepo.get imageUrl

		@_uniforms.imageAtlasSlot.set 0

		@_imageAtlasTexture.assignToSlot 0

		return

	_preparePictureAtlasTexture: (imageUrl) ->

		return if @_pictureAtlasTexture?

		@_pictureAtlasTexture = @_scene._textureRepo.get imageUrl
		# @_pictureAtlasTexture.flipY()

		@_uniforms.pictureAtlasSlot.set 1

		@_pictureAtlasTexture.assignToSlot 1

		return

	_applyBlending: ->

		if @_blendingMode is 0

			@_gila.blending.disable()

			return

		@_gila.blending.enable()

		switch @_blendingMode

			when 1

				@_gila.blend
				.src.srcAlpha()
				.dst.oneMinusSrcAlpha()
				.update()

			when 2

				@_gila.blend
				.src.srcAlpha()
				.dst.one()
				.update()

		return

	_prepareParamHolder: (holder) ->

		# fillWithImage
		if @flags.fillWithImage and holder.fillWithImageProps.updated

			# get atlas data of the element's image
			image = @_scene.atlas.getImageData holder.fillWithImageProps.image

			# prepare the atls texture, if it's not already
			@_prepareImageAtlasTexture image.atlasUrl

			# the shader needs to know the coordinates of the image
			# in the shader atlas
			holder.fillWithImageCoords.set image.coords

			# Let's not redo all this agian
			holder.fillWithImageProps.updated = no

		# maskWithImage
		if @flags.maskWithImage and holder.maskWithImageProps.updated

			# get atlas data of the element's image
			image = @_scene.atlas.getImageData holder.maskWithImageProps.image

			# prepare the atls texture, if it's not already
			@_prepareImageAtlasTexture image.atlasUrl

			# the shader needs to know the coordinates of the image
			# in the shader atlas
			holder.maskWithImageCoords.set image.coords

			holder.maskWithImageChannel[0] = holder.maskWithImageProps.channel || 0

			# Let's not redo all this agian
			holder.maskWithImageProps.updated = no

		# maskWithImage
		if @flags.maskOnImage and holder.maskOnImageProps.updated

			# get atlas data of the element's image
			image = @_scene.atlas.getImageData holder.maskOnImageProps.image

			# prepare the atls texture, if it's not already
			@_preparePictureAtlasTexture image.atlasUrl

			# the shader needs to know the coordinates of the image
			# in the shader atlas
			holder.maskOnImageCoords.set image.coords

			# holder.maskOnImageCoords[2] = 0.7

			# Let's not redo all this agian
			holder.maskOnImageProps.updated = no

		return

	paint: (holders) ->

		# start by activating the program
		@_program.activate()

		for holder in holders

			@_prepareParamHolder holder

		# all done with attributes, let's send it over
		@_theBuffer.streamData holders.buffer

		do @_applyBlending

		@_gila.drawPoints 0, holders.length

		return