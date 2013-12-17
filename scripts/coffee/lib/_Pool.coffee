module.exports = class _Pool

	constructor: (scene) ->

		@_timing = @_scene.timing

		@putIn scene

	putIn: (scene) ->

		if @_scene? and @_scene isnt scene

			@_scene._removePool @

			@_scene = scene

			@_scene._addPool @

		@

	quit: ->

		throw Error "All pools must have a quit method"

	_redraw: ->

		throw Error "Pool has not implemented _redraw()"