exposeMethods = require './utility/exposeMethods'

module.exports = class _El

	self = @

	constructor: ->

		exposeMethods @

		defaultScene = Scene.getDefaultScene()

		if defaultScene?

			defaultScene.timing.nextTick =>

				if not @parent? and defaultContainer = Scene.getDefaultContainer()

					@putIn defaultContainer

				return

		@_children = []

		@parent = null

		@_scene = null

		@_gila = null

	putIn: (sceneOrEl) ->

		sceneOrEl._adopt @

		if sceneOrEl instanceof _El

			@parent = sceneOrEl

		else

			@parent = null

		@_scene = sceneOrEl._scene

		@_timing = @_scene.timing

		@_gila = @_scene._gila

		do @_respondToParentChange

		@

	_adopt: (el) ->

		do @_scheduleRedraw

		@_children.push el

		return

	# This gets called when element is put inside another element
	_respondToParentChange: ->

		throw Error 'Any class extending _El must respond to parent change in some way'

	_redraw: ->

		throw Error "Element has not implemented _redraw()"

	_scheduleRedraw: ->

		if @_scene? then do @_scene._scheduleRedraw

		return

	_getTickNumber: ->

		return @_timing.tickNumber if @_timing?

		return 0

	hasParent: ->

		@parent?

Scene = require './Scene'