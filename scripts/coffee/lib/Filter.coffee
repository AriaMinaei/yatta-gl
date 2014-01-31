shaders = require './filter/shaders'

rectangleVx = new Float32Array [
	-1, -1,
	-1,  1,
	 1, -1,

	 1, -1,
	-1,  1,
	 1,  1
]

module.exports = class Filter

	constructor: (@_layer) ->

		@_scene = @_layer

		@_layer._adopt @

		@_gila = @_scene._gila

		do @_initProgram

	_initProgram: ->

		@_useVao = @_gila.extensions.vao.isAvailable()

		unless @_useVao

			throw Error "Currently, we need OES_vertex_array_object extension to work"

		else

			@_vao = @_gila.extensions.vao.create()

			@_vao.bind()

		vert = @_gila.getVertexShader 'filter-shader-vert', shaders.vert

		frag = @_gila.getFragmentShader 'filter-shader-frag', shaders.frag

		@_program = @_gila.getProgram vert, frag

		@_layerBeneathUniform = @_program.uniform '1i', 'layerBeneath'

		@_gila.makeArrayBuffer().staticData rectangleVx

		@_program.attr('vx').enable().readAsFloat 2, no, 8, 0

		@_vao.unbind()

	_redraw: ->

		prevFb = @_layer._prevFrameBuffer

		unless prevFb?

			throw Error "Filter needs access to a frame buffer"

		@_vao.bind()

		@_program.activate()

		@_layerBeneathUniform.set prevFb.getColorTexture().assignToAUnit()

		@_gila.drawTriangles 0, 6

		@_vao.unbind()