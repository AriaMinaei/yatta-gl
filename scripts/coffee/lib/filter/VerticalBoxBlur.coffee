module.exports = class VerticalBoxBlur

	constructor: (@filter, @id) ->

		@_intensity = new Float32Array 1
		@_intensityUniform = null
		@_height = @filter._scene._dims.height

	_getFragHead: ->

		"uniform float vbb_#{@id}_intensity;"

	_getFragBody: ->

		"
		vec4 vbb_#{@id}_sum = vec4(0.0);

		vbb_#{@id}_sum += texture2D(layerBeneath, vec2(vTexCoord.x, vTexCoord.y - 3.0 * vbb_#{@id}_intensity));
		vbb_#{@id}_sum += texture2D(layerBeneath, vec2(vTexCoord.x, vTexCoord.y - 2.0 * vbb_#{@id}_intensity));
		vbb_#{@id}_sum += texture2D(layerBeneath, vec2(vTexCoord.x, vTexCoord.y - vbb_#{@id}_intensity));
		vbb_#{@id}_sum += texture2D(layerBeneath, vec2(vTexCoord.x, vTexCoord.y));
		vbb_#{@id}_sum += texture2D(layerBeneath, vec2(vTexCoord.x, vTexCoord.y + vbb_#{@id}_intensity));
		vbb_#{@id}_sum += texture2D(layerBeneath, vec2(vTexCoord.x, vTexCoord.y + 2.0 * vbb_#{@id}_intensity));
		vbb_#{@id}_sum += texture2D(layerBeneath, vec2(vTexCoord.x, vTexCoord.y + 3.0 * vbb_#{@id}_intensity));

		color = vbb_#{@id}_sum / 7.0;
		"

	_useProgram: (p) ->

		@_intensityUniform = p.uniform '1f', "vbb_#{@id}_intensity"

		return

	setIntensity: (i) ->

		@_intensity[0] = i / @_height

		@

	_redraw: ->

		@_intensityUniform.fromArray @_intensity

		return