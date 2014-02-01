module.exports = class NegativeEffect

	constructor: (@filter, @id) ->

		@_intensity = new Float32Array 1

		@_intensityUniform = null

	_getFragHead: ->

		"uniform float negative_#{@id}_intensity;"

	_getFragBody: ->

		"color = mix(color, vec4(1.0 - color.rgb, color[3]), negative_#{@id}_intensity);"

	_useProgram: (p) ->

		@_intensityUniform = p.uniform '1f', "negative_#{@id}_intensity"

		return

	setIntensity: (i) ->

		@_intensity[0] = i

		@

	_redraw: ->

		@_intensityUniform.fromArray @_intensity

		return