matrixify = require 'transformation/scripts/js/lib/matrixify'
{mat4} = require 'gl-matrix/src/gl-matrix/mat4'
TransformationApi = require 'transformation'

module.exports = class Transformation

	constructor: (@el) ->

		@api = new TransformationApi

		@_localMatrix = mat4.create()

		@_lastApiChangeTime = 0

		@_lastLocalMatrixUpdateTime = -1

		@_finalMatrix = mat4.create()

	getMatrix: ->

		do @_getFinalMatrix

	_getLocalMatrix: ->

		if @_lastApiChangeTime isnt @_lastLocalMatrixUpdateTime

			do @_calculateLocalMatrix

			@_lastLocalMatrixUpdateTime = @_getTickNumber()

		@_localMatrix

	_getTickNumber: ->

		@el._getTickNumber()

	_calculateLocalMatrix: ->

		has = @api._has

		out = mat4.identity @_localMatrix

		matrixify.convert out, @api

		out

	_getFinalMatrix: ->

		do @_calculateFinalMatrix

	_calculateFinalMatrix: ->

		unless @el.hasParent()

			return @_getLocalMatrix()

		mat4.multiply @_finalMatrix, @_getParentMatrix(), @_getLocalMatrix()

	_getParentMatrix: ->

		@el.parent._transformation.getMatrix()

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

						@_transformation._lastApiChangeTime = @_getTickNumber()

						func.apply @_transformation.api, arguments

						@

				else

					toExpose[name] = ->

						func.apply @_transformation.api, arguments

				return

		toExpose