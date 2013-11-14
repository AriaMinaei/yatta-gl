module.exports = class _El

	constructor: ->

		defaultScene = Scene.getDefaultScene()

		if defaultScene?

			defaultScene.timing.nextTick =>

				if not @parent? and defaultContainer = Scene.getDefaultContainer()

					@putIn defaultContainer

				return

		@_children = []

		@parent = null

		@scene = null

	putIn: (sceneOrEl) ->

		sceneOrEl._adopt @

		@parent = sceneOrEl

		@scene = sceneOrEl.scene

		@_timing = @scene.timing

		do @_respondToParentChange

		@

	_respondToParentChange: ->

		throw Error "Any class extending _El must respond to parent change in
			some way"

Scene = require './Scene'