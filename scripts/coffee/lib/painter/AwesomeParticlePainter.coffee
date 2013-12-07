_Painter = require '../_Painter'

{vert, frag} = require './awesomeParticlePainter/shaders'

module.exports = class AwesomeParticlePainter extends _Painter

	self = @

	_init: (scene, @flags, @index) ->

		@_program = do @_getProgram

		@_uniforms =

			# size: @_program.uniform '1f', 'size'

			color: @_program.uniform '3f', 'color'

		@_theBuffer = @_gila.makeArrayBuffer()

		@_attribs =

			pos: @_program.attr('pos').enable()

			size: @_program.attr('size').enable()

		@_floats = new Float32Array [0, 0, 0, 120]

		do @_setupAttribs


	_getProgram: ->

		vert = @_gila.getVertexShader 'awesome-particle-shader-vert', vert, @flags
		frag = @_gila.getFragmentShader 'awesome-particle-shader-frag', frag, @flags

		@_gila.getProgram vert, frag

	_setupAttribs: ->

		@_program.activate()

		@_theBuffer.bind()

		step = Float32Array.BYTES_PER_ELEMENT

		total = 3 + 1

		stride = step * total

		@_attribs.pos.readAsFloat 3, no, stride, 0

		@_attribs.size.readAsFloat 1, no, stride, step * 3

	paint: (floats) ->

		@_floats[0] += 0.01

		@_program.activate()

		@_theBuffer.data @_floats

		@_uniforms.color.set 0.5, 0.7, 0.9

		@_gila.drawPoints 0, 1