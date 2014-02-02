module.exports = class DebugEffect

	constructor: (@filter, @id) ->

	_getFragHead: ->

		""

	_getFragBody: ->

		"color = vec4(1.0, 0.0, 0.0, color.w);"

	_useProgram: (p) ->

		return

	_redraw: ->

		return