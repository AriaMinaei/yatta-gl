Esterakt = require 'esterakt'
shaders = require './ParticlePainter/shaders'

module.exports = class ParticlePainter

	constructor: (@_scene, @flags) ->

		@_gila = @_scene._gila

		@_init @_scene

	_init: ->

		@_currentBlending = -1

		@_program = do @_getProgram

		@_program.activate()

		@_uniforms =

			win: @_program.uniform('2f', 'win')
			.set(@_scene._dims.perceivedWidth, @_scene._dims.perceivedHeight)

		@_imageAtlasTexture = null

		@_pictureAtlasTexture = null

		do @_setupDataStructure

		@_theBuffer = @_gila.makeArrayBuffer()

		do @_setupAttribs

	_setupDataStructure: ->

		@_baseParams = {}

		flags = @flags

		@_struct = new Esterakt

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
			@_baseParams.fillWithImageProps = image: null

			# The attribute to the coordinates of the image in the atlas
			@_struct.float 'fillWithImageCoords', 4

			# We should enable the atlas
			@_uniforms.imageAtlasSlot = @_program.uniform '1i', 'imageAtlasSlot'

		else if flags.maskOnImage

			# These will be set in the element api
			@_baseParams.maskOnImageProps = image: null

			# The attribute to the coordinates of the image in the atlas
			@_struct.float 'maskOnImageCoords', 4

			# We should enable the atlas
			@_uniforms.pictureAtlasSlot = @_program.uniform '1i', 'pictureAtlasSlot'

		else

			@_struct.unsignedByte 'color', 4, [255, 255, 255, 255], yes

		if flags.maskWithImage

			# These will be set in the element api
			@_baseParams.maskWithImageProps = image: null, channel: 0

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

	updateFillWithImage: (holder, image) ->

		holder.fillWithImageProps.image = image

		# get atlas data of the element's image
		image = @_scene.atlas.getImageData image

		# prepare the atls texture, if it's not already
		@_prepareImageAtlasTexture image.atlasUrl

		# the shader needs to know the coordinates of the image
		# in the shader atlas
		holder.fillWithImageCoords.set image.coords

		return

	updateMaskOnImage: (holder, image) ->

		holder.maskOnImageProps.image = image

		# get atlas data of the element's image
		image = @_scene.atlas.getImageData image

		# prepare the atls texture, if it's not already
		@_preparePictureAtlasTexture image.atlasUrl

		# the shader needs to know the coordinates of the image
		# in the shader atlas
		holder.maskOnImageCoords.set image.coords

		return

	updateMaskWithImage: (holder, image, channel) ->

		holder.maskWithImageProps.image = image

		channel = parseInt(channel) || 0

		holder.maskWithImageProps.channel = channel

		# get atlas data of the element's image
		image = @_scene.atlas.getImageData image

		# prepare the atls texture, if it's not already
		@_prepareImageAtlasTexture image.atlasUrl

		# the shader needs to know the coordinates of the image
		# in the shader atlas
		holder.maskWithImageCoords.set image.coords

		holder.maskWithImageChannel[0] = channel

		return

	paint: (buffer, count) ->

		@_program.activate()

		@_theBuffer.streamData buffer

		do @_applyBlending

		@_gila.drawPoints 0, count

		return

	@possibleFlags: ['fillWithImage', 'maskWithImage', 'maskOnImage', 'tint', 'blending']