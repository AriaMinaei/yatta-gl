module.exports = class HorizontalBoxBlur

	constructor: (@filter, @id) ->

		@_intensity = new Float32Array 1
		@_intensityUniform = null
		@_width = @filter._scene._dims.width

	_getFragHead: ->

		"uniform float hbb_#{@id}_intensity;"

	_getFragBody: ->

		"
		vec4 hbb_#{@id}_sum = vec4(0.0);

		hbb_#{@id}_sum += texture2D(layerBeneath, vec2(vTexCoord.x - 3.0 * hbb_#{@id}_intensity, vTexCoord.y));
		hbb_#{@id}_sum += texture2D(layerBeneath, vec2(vTexCoord.x - 2.0 * hbb_#{@id}_intensity, vTexCoord.y));
		hbb_#{@id}_sum += texture2D(layerBeneath, vec2(vTexCoord.x - hbb_#{@id}_intensity, vTexCoord.y));
		hbb_#{@id}_sum += texture2D(layerBeneath, vec2(vTexCoord.x, vTexCoord.y));
		hbb_#{@id}_sum += texture2D(layerBeneath, vec2(vTexCoord.x + hbb_#{@id}_intensity, vTexCoord.y));
		hbb_#{@id}_sum += texture2D(layerBeneath, vec2(vTexCoord.x + 2.0 * hbb_#{@id}_intensity, vTexCoord.y));
		hbb_#{@id}_sum += texture2D(layerBeneath, vec2(vTexCoord.x + 3.0 * hbb_#{@id}_intensity, vTexCoord.y));

		color = hbb_#{@id}_sum / 7.0;
		"

	_useProgram: (p) ->

		@_intensityUniform = p.uniform '1f', "hbb_#{@id}_intensity"

		return

	setIntensity: (i) ->

		@_intensity[0] = i / @_width

		@

	_redraw: ->

		@_intensityUniform.fromArray @_intensity

		return