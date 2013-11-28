TransformationApi = require 'transformation'
{mat4, vec3} = require 'gl-matrix'

module.exports = class Transformation

	constructor: (@el) ->

		@api = new TransformationApi

		@_localMatrix = mat4.create()

		@_lastApiChangeTime = 0

		@_lastLocalMatrixUpdateTime = -1

	getMatrix: ->

		localMatrix = @_getLocalMatrix()

	_getLocalMatrix: ->

		if @_lastApiChangeTime > @_lastLocalMatrixUpdateTime

			do @_calculateLocalMatrix

			@_lastLocalMatrixUpdateTime = @_getTickNumber()

		@_localMatrix

	_getTickNumber: ->

		@el._timing.tickNumber

	_calculateLocalMatrix: ->

		has = @api._has

		props = @api._current

		out = mat4.identity @_localMatrix

		if has.movement

			mat4.translate out, out, [props[0], props[1], props[2]]

		out

	@_methodsToExpose: do ->

		toExpose = {}

		for name of TransformationApi::

			continue if name in ['constructor', 'temporarily', 'commit', 'rollback', 'toPlainCss']

			do ->

				func = TransformationApi::[name]

				# for setter methods
				if name.substr(0, 3) isnt 'get'

					toExpose[name] = ->

						do @_scheduleRedraw

						@_transformation._lastApiChangeTime = @_transformation._getTickNumber()

						func.apply @_transformation.api, arguments

						@

				else

					toExpose[name] = ->

						func.apply @_transformation.api, arguments

				return

		toExpose