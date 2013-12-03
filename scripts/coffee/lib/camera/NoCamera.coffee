_Camera = require '../_Camera'
{mat4} = require 'gl-matrix/src/gl-matrix/mat4'

module.exports = class NoCamera extends _Camera

	constructor: ->

		@_perspectiveMatrix = mat4.create()

		@_props =

			aspectRatio: 0

		super

	_reactToPropsChange: ->

		do @_calculatePerspectiveMatrix

		return

	ratio: (r) ->

		@_props.aspectRatio = parseFloat r

		do @_reactToPropsChange

		@

	_getPerspectiveMatrix: ->

		@_perspectiveMatrix

	_calculatePerspectiveMatrix: ->

		@_perspectiveMatrix[5] = @_props.aspectRatio

		return

	_respondToParentChange: ->

		{perceivedWidth, perceivedHeight} = @_scene._dims

		@ratio perceivedWidth / perceivedHeight

		do @_getPerspectiveMatrix

		return