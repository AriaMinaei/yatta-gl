{classic} = require 'utila'

classic.mixing module.exports = class El

	constructor: ->

		@_children = []

		@parent = []

		@scene = null

	putIn: (sceneOrEl) ->

		sceneOrEl._adopt @

		@parent = sceneOrEl

		@scene = sceneOrEl.scene

		@_timing = @scene.timing

		@