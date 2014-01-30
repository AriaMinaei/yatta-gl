module.exports = class _Pool

	constructor: (layer) ->

		@putIn layer

	putIn: (layer) ->

		if @_layer isnt layer

			if @_layer?

				@_layer._notYourChildAnymore @

			@_layer = layer

			@_layer._adopt @

		@_scene = @_layer._scene

		@_timing = @_layer.timing

		@

	quit: ->

		throw Error "Pool has not implemented a quit method"

	_redraw: ->

		throw Error "Pool has not implemented _redraw()"