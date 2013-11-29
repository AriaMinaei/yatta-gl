_Camera = require '../_Camera'
{mat4} = require 'gl-matrix/src/gl-matrix/mat4'

module.exports = class Perspective extends _Camera

	constructor: ->

		super

		@_perspectiveMatrix = mat4.create()

		@_perspectiveMatrix.lastUpdateTime = -1

		@_lastPropsChangeTime = 0

		@_props =

			# Y-Axis field of view
			fovy: 45

			aspectRatio: 0

			near: 0.1

			far: 1000.0

	_reactToPropsChange: ->

		@_lastPropsChangeTime = @_getTickNumber()

		return

	fov: (fovy) ->

		@_props.fovy = parseFloat fovy

		do @_reactToPropsChange

		@

	clip: (near, far) ->

		@nearClip near

		@farClip far

		@

	nearClip: (near) ->

		@_props.near = parseFloat near

		do @_reactToPropsChange

		@

	farClip: (far) ->

		@_props.far = parseFloat far

		do @_reactToPropsChange

		@

	ratio: (r) ->

		@_props.aspectRatio = parseFloat r

		do @_reactToPropsChange

		@

	_getPerspectiveMatrix: ->

		if @_lastPropsChangeTime > @_perspectiveMatrix.lastUpdateTime

			do @_calculatePerspectiveMatrix

			@_perspectiveMatrix.lastUpdateTime = @_getTickNumber()

		@_perspectiveMatrix

	_calculatePerspectiveMatrix: ->

		mat4.perspective @_perspectiveMatrix, @_props.fovy, @_props.aspectRatio, @_props.near, @_props.far

		return

	_respondToParentChange: ->

		{perceivedWidth, perceivedHeight} = @_scene._dims

		@ratio perceivedWidth / perceivedHeight

		do @_getPerspectiveMatrix

		return