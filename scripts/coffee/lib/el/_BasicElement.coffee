_El = require '../_El'
Transformation = require './property/Transformation'

module.exports = class _BasicElement extends _El

	constructor: ->

		super

		@_transformation = new Transformation @

	@_methodsToExpose: [Transformation._methodsToExpose]