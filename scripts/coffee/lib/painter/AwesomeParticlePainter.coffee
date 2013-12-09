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
			@_uniforms.atlasSlot = @_program.uniform '1i', 'atlasSlot'

		else if flags.maskOnImage

			throw Error "maskOnImage not implemented yet"

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
			@_uniforms.atlasSlot = @_program.uniform '1i', 'atlasSlot'

	makeParamHolder: ->

		@_struct.makeParamHolder @_baseParams

	_init: (scene, @flags, @index) ->

		@_program = do @_getProgram

		@_program.activate()

		@_uniforms =

			win: @_program.uniform('2f', 'win')
			.set(@_scene._dims.perceivedWidth, @_scene._dims.perceivedHeight)

		@_atlasTexture = null

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

	_prepareAtlasTexture: (imageUrl) ->

		return if @_atlasTexture?

		@_atlasTexture = @_scene._textureRepo.get imageUrl

		@_uniforms.atlasSlot.set 0

		@_atlasTexture.assignToSlot 0

		return

	paint: (params) ->

		# start by activating the program
		@_program.activate()

		# fillWithImage
		if @flags.fillWithImage and params.fillWithImageProps.updated

			# get atlas data of the element's image
			image = @_scene.atlas.getImageData params.fillWithImageProps.image

			# prepare the atls texture, if it's not already
			@_prepareAtlasTexture image.atlasUrl

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
			@_prepareAtlasTexture image.atlasUrl

			# the shader needs to know the coordinates of the image
			# in the shader atlas
			params.maskWithImageCoords.set image.coords

			params.maskWithImageChannel[0] = params.maskWithImageProps.channel || 0

			# Let's not redo all this agian
			params.maskWithImageProps.updated = no

		# all done with attributes, let's send it over
		@_theBuffer.data params.__buffer

		@_gila.drawPoints 0, 1