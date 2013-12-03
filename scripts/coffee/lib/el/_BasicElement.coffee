_El = require '../_El'
Transformation = require './property/Transformation'

module.exports = class _BasicElement extends _El

	constructor: ->

		super

		@_transformation = new Transformation @

	_redrawChildren: ->

		child._redraw() for child in @_children

		return


	_getCameraPerspective: ->

		@_scene._currentCamera._getPerspectiveMatrix()

	@_methodsToExpose: [Transformation._methodsToExpose]