_Camera = require '../_Camera'
{mat4} = require 'gl-matrix'

module.exports = class Perspective extends _Camera

	constructor: (fovy = 45) ->

		@_props =

			# Y-Axis field of view
			fovy: 0

			aspectRatio: 0

			near: 0

			far: 0

	getPerspectiveMatrix: ->

		# for now, let's just return our default perspective
		@_perspectiveMatrix

	_respondToParentChange: ->

		# Just reset everything to a pretty normal camera,
		# till we implement a full camera system
		mat4.perspective @_perspectiveMatrix, 45,

			@scene._dims.perceivedWidth, @scene._dims.perceivedHeight,

			0.1, 100.0

		return