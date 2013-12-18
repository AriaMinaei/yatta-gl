module.exports = class _Pool

	constructor: (scene) ->

		@putIn scene

	putIn: (scene) ->

		if @_scene isnt scene

			if @_scene?

				@_scene._notYourChildAnymore @

			@_scene = scene

			@_scene._adopt @

		@_timing = @_scene.timing

		@

	quit: ->

		throw Error "Pool has not implemented a quit method"

	_redraw: ->

		throw Error "Pool has not implemented _redraw()"