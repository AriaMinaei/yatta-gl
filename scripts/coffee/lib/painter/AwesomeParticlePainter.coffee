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

			# The attributes to the coordinates of the image in the atlas
			@_struct.float 'fillWithImageCoords', 4

			# We should enable the atlas
			@_uniforms.atlasSlot = @_program.uniform '1i', 'atlasSlot'

		else if flags.maskOnImage

			throw Error "maskOnImage not implemented yet"

		else

			@_struct.unsignedByte 'color', 4, yes

	makeParamHolder: ->

		@_struct.makeParamHolder @_baseParams

	_init: (scene, @flags, @index) ->

		@_program = do @_getProgram

		@_uniforms = {}

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

		console.log imageUrl

		return if @_atlasTexture?

		@_atlasTexture = @_scene._textureRepo.get imageUrl

		@_uniforms.atlasSlot.set 0

		@_atlasTexture.assignToSlot 0

		return

	paint: (params) ->

		buffer = params.__buffer

		@_program.activate()

		@_theBuffer.data buffer

		if @flags.fillWithImage

			# see which atlas it is using
			if params.fillWithImageProps.updated

				params.fillWithImageProps.updated = no

				image = @_scene.atlas.getImageData params.fillWithImageProps.image

				@_prepareAtlasTexture image.atlasUrl

				params.fillWithImageCoords[0] = image.coords[0]
				params.fillWithImageCoords[1] = image.coords[1]
				params.fillWithImageCoords[2] = image.coords[2]
				params.fillWithImageCoords[3] = image.coords[3]

		# @_uniforms.color.set 0.5, 0.7, 0.9

		@_gila.drawPoints 0, 1