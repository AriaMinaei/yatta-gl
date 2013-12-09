FloatStruct = require '../utility/FloatStruct'
_Painter = require '../_Painter'
shaders = require './awesomeParticlePainter/shaders'

module.exports = class AwesomeParticlePainter extends _Painter

	self = @

	_setupDataStructure: ->

		@_baseParams = {}

		flags = @flags

		@_struct = new FloatStruct

		@_struct.float 'size', 1

		@_struct.float 'pos', 3

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

			@_struct.unsignedByte 'color', 4, yes

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

	_init: (scene, @flags, @index) ->

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

		vert = @_gila.getVertexShader 'awesome-particle-shader-vert',

			shaders.vert, flagsInCaps

		frag = @_gila.getFragmentShader 'awesome-particle-shader-frag',

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

	paint: (params) ->

		# start by activating the program
		@_program.activate()

		# fillWithImage
		if @flags.fillWithImage and params.fillWithImageProps.updated

			# get atlas data of the element's image
			image = @_scene.atlas.getImageData params.fillWithImageProps.image

			# prepare the atls texture, if it's not already
			@_prepareImageAtlasTexture image.atlasUrl

			# the shader needs to know the coordinates of the image
			# in the shader atlas
			params.fillWithImageCoords.set image.coords

			# Let's not redo all this agian
			params.fillWithImageProps.updated = no

		# maskWithImage
		if @flags.maskWithImage and params.maskWithImageProps.updated

			# get atlas data of the element's image
			image = @_scene.atlas.getImageData params.maskWithImageProps.image

			# prepare the atls texture, if it's not already
			@_prepareImageAtlasTexture image.atlasUrl

			# the shader needs to know the coordinates of the image
			# in the shader atlas
			params.maskWithImageCoords.set image.coords

			params.maskWithImageChannel[0] = params.maskWithImageProps.channel || 0

			# Let's not redo all this agian
			params.maskWithImageProps.updated = no

		# maskWithImage
		if @flags.maskOnImage and params.maskOnImageProps.updated

			# get atlas data of the element's image
			image = @_scene.atlas.getImageData params.maskOnImageProps.image

			# prepare the atls texture, if it's not already
			@_preparePictureAtlasTexture image.atlasUrl

			# the shader needs to know the coordinates of the image
			# in the shader atlas
			params.maskOnImageCoords.set image.coords

			# params.maskOnImageCoords[2] = 0.7

			# Let's not redo all this agian
			params.maskOnImageProps.updated = no

		# all done with attributes, let's send it over
		@_theBuffer.data params.__buffer

		@_gila.drawPoints 0, 1