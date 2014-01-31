module.exports = class Layer

	constructor: (@_scene) ->

		@_gila = @_scene._gila

		@_children = []

	_redraw: (@_prevFrameBuffer) ->

		child._redraw() for child in @_children

		return

	_adopt: (el) ->

		@_children.push el

		return