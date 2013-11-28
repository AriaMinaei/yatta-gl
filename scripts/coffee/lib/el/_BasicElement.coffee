_El = require '../_El'
Transformation = require './property/Transformation'

module.exports = class _BasicElement extends _El

	constructor: ->

		super

		@_transformation = new Transformation @

	_redraw: ->

		child._redraw() for child in @_children

		return

	@_methodsToExpose: [Transformation._methodsToExpose]