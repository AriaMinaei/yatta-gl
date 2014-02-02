module.exports = class GlowEffect

	constructor: (@filter, @id) ->

		@_intensity = new Float32Array 1
		@_intensityUniform = null

	_getFragHead: ->

		"uniform float glow_#{@id}_intensity;"

	_getFragBody: ->

		"color = (1.0 + glow_#{@id}_intensity * vec4(smoothstep(0.0, 1.0, color.rgb), color.w)) * color;"

	_useProgram: (p) ->

		@_intensityUniform = p.uniform '1f', "glow_#{@id}_intensity"

		return

	setIntensity: (i) ->

		@_intensity[0] = i

		@

	_redraw: ->

		@_intensityUniform.fromArray @_intensity

		return