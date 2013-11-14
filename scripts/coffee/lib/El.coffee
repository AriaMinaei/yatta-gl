{classic} = require 'utila'
Scene = require './Scene'

classic.mixing module.exports = class El

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

		@