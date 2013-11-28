module.exports = class Dims2D

	constructor: (@el) ->

		@_dims = new Float32Array 2

	setWidth: (w) ->

		@_dims[0] = w

		@

	setHeight: (h) ->

		@_dims[1] = h

		@

	getWidth: ->

		@_dims[0]

	getHeight: ->

		@_dims[1]

	getDims: ->

		@_dims

	@_methodsToExpose: do ->

		toExpose = {}

		for name of Dims2D::

			continue if name in ['constructor']

			do ->

				func = Dims2D::[name]

				# for setter methods
				if name.substr(0, 3) isnt 'get'

					toExpose[name] = ->

						do @_scheduleRedraw

						func.apply @_dims, arguments

						@

				else

					toExpose[name] = ->

						func.apply @_dims, arguments

				return

		toExpose