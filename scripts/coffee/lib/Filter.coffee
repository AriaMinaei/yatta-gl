shaders = require './filter/shaders'
NegativeEffect = require './filter/NegativeEffect'
GlowEffect = require './filter/GlowEffect'

rectangleVx = new Float32Array [
	-1, -1,
	-1,  1,
	 1, -1,

	 1, -1,
	-1,  1,
	 1,  1
]

module.exports = class Filter

	@_fragsCount: 0

	constructor: (@_layer) ->

		@_scene = @_layer._scene

		@_layer._adopt @

		@_gila = @_scene._gila

		@_effects = []

		@_useVao = no

		@_program = null

		@_vao = null

		@_layerBeneathUniform = null

		@_shouldReinit = yes

	addEffect: (effectName, reinitProgram = yes) ->

		console.log self.effects

		fx = new self.effects[effectName] @, @_effects.length

		@_effects.push fx

		@_shouldReinit = yes

		do @_reinitProgram if reinitProgram

		fx

	_reinitProgram: ->

		@_useVao = @_gila.extensions.vao.isAvailable()

		unless @_useVao

			throw Error "Currently, we need OES_vertex_array_object extension to work"

		else

			@_vao = @_gila.extensions.vao.create()

			@_vao.bind()

		vert = @_gila.getVertexShader 'filter-shader-vert', shaders.vert

		frag = @_getFragShader()

		@_program = @_gila.getProgram vert, frag

		@_layerBeneathUniform = @_program.uniform '1i', 'layerBeneath'

		@_gila.makeArrayBuffer().staticData rectangleVx

		@_program.attr('vx').enable().readAsFloat 2, no, 8, 0

		fx._useProgram @_program for fx in @_effects

		@_vao.unbind()

		@_shouldReinit = no

	_getFragShader: ->

		frag = """

		precision highp float;

		varying vec2 vTexCoord;

		uniform sampler2D layerBeneath;

		"""

		frag += fx._getFragHead() + "\n" for fx in @_effects

		frag += """
		void main() {
			vec4 color = texture2D(layerBeneath, vTexCoord);
		"""

		frag += fx._getFragBody() + "\n" for fx in @_effects

		frag += """
			gl_FragColor = color;
		}
		"""

		@_gila.getFragmentShader 'filter-shader-frag-' + self._fragsCount++,

			frag

	_redraw: ->

		if @_shouldReinit

			throw Error "Filter needs to reinitialize"

		prevFb = @_layer._prevFrameBuffer

		unless prevFb?

			throw Error "Filter needs access to a frame buffer"

		@_vao.bind()

		@_program.activate()

		@_layerBeneathUniform.set prevFb.getColorTexture().assignToAUnit()

		fx._redraw() for fx in @_effects

		@_gila.drawTriangles 0, 6

		@_vao.unbind()

	@effects:

		negative: NegativeEffect
		glow: GlowEffect

	self = @