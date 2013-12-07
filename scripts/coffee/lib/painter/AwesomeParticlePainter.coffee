FloatStruct = require '../utility/FloatStruct'
_Painter = require '../_Painter'
shaders = require './awesomeParticlePainter/shaders'

module.exports = class AwesomeParticlePainter extends _Painter

	self = @

	_setupDataStructure: ->

		flags = @flags

		@_struct = new FloatStruct

		@_struct.float 'size', 1

		@_struct.float 'pos', 3

		# @_struct.float 'zRotation', 1

		if flags.fillImage

			throw Error "fillImage not implemented yet"

		else if flags.maskOnImage

			throw Error "maskOnImage not implemented yet"

		else

			@_struct.unsignedByte 'color', 4, yes

	makeParamHolder: ->

		do @_struct.makeParamHolder

	_init: (scene, @flags, @index) ->

		do @_setupDataStructure

		@_program = do @_getProgram

		# @_uniforms =

			# color: @_program.uniform '3f', 'color'

		@_theBuffer = @_gila.makeArrayBuffer()

		do @_setupAttribs


	_getProgram: ->

		vert = @_gila.getVertexShader 'awesome-particle-shader-vert',

			shaders.vert, @flags

		frag = @_gila.getFragmentShader 'awesome-particle-shader-frag',

			shaders.frag, @flags

		@_gila.getProgram vert, frag

	_setupAttribs: ->

		@_program.activate()

		@_theBuffer.bind()

		stride = @_struct.getStride()

		for el in @_struct.getElements()

			@_program.attr(el.name).enable()._pointer el.size,

				el.glType, el.normalized, stride, el.offset

		return

	paint: (params) ->

		buffer = params.__buffer

		@_program.activate()

		@_theBuffer.data buffer

		# @_uniforms.color.set 0.5, 0.7, 0.9

		@_gila.drawPoints 0, 1