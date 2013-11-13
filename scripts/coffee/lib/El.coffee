define ['./Scene'], (Scene) ->

	class El

		constructor: ->

			@_children = []

			@parent = []

			@scene = null



		putIn: (sceneOrEl) ->

			sceneOrEl.adopt @

			@parent = sceneOrEl

			@scene = sceneOrEl.scene

			@




