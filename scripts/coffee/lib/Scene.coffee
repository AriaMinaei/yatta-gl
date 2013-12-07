TextureRepo = require './TextureRepo'
Timing = require 'raf-timing'
Gila = require 'gila'

module.exports = class Scene

	self = @

	@_scenes: []

	constructor: (idOrCanvas, debug = no) ->

		@_scene = @

		@id = self._scenes.length

		self._scenes.push @

		@_dims =

			# Actual width and height of the canvas
			width: 0
			height: 0

			# If we resize the canvas, and scale it up (to get lower resolution),
			# then we wouldn't want the size of our elements which are set
			# according to our resolution to change.
			perceivedWidth: 0
			perceivedHeight: 0

		@debug = Boolean debug

		@_setCanvas idOrCanvas

		@_children = []

		do @_initTiming

		@_textureRepo = new TextureRepo @

		@_setCurrentCamera new NoCamera @

	getCurrentCamera: ->

		@_currentCamera

	_setCurrentCamera: (cam) ->

		@_currentCamera = cam

		return

	_initTiming: ->

		@_boundTick = (t) =>

			@_tick t

			return

		@timing = new Timing

		@_rafId = Timing.requestAnimationFrame @_boundTick

		do @_scheduleRedraw

		return

	eachFrame: (cb) ->

		func = (t) ->

			cb t, cancel

			return

		cancel = ->

			@timing.cancelBeforeEachFrame func

			return

		@timing.beforeEachFrame func

		@

	_tick: (t) ->

		@_rafId = Timing.requestAnimationFrame @_boundTick

		@timing.tick t

		# if @_shouldRedraw

		# 	@_shouldRedraw = no

		do @_redraw

		return

	_redraw: ->

		@_gila.clear()

		child._redraw() for child in @_children

		return

	_scheduleRedraw: ->

		return if @_shouldRedraw

		@_shouldRedraw = yes

		return

	_setCanvas: (idOrCanvas) ->

		if typeof idOrCanvas is 'string'

			canvas = document.getElementById idOrCanvas

			unless canvas?

				throw Error "Cannot find canvas with id '#{idOrCanvas}'"

		else

			canvas = idOrCanvas

		unless canvas instanceof HTMLCanvasElement

			throw Error "canvas must be a canvas element"

		@canvas = canvas


		@_dims.width = canvas.width
		@_dims.height = canvas.height

		@_dims.perceivedWidth = canvas.width
		@_dims.perceivedHeight = canvas.height

		do @_initGila

		return

	_initGila: ->

		@_gila = new Gila @canvas, @debug

		@_gila.setViewportDims 0, 0, @_dims.width, @_dims.height

		@_gila.setClearColor 0, 0, 0.1, 1

		@_gila.blending.enable()

		@_gila.blend
		.src.srcAlpha()
		.dst.one()
		.update()

		return

	_adopt: (el) ->

		do @_scheduleRedraw

		@_children.push el

		return

NoCamera = require './camera/NoCamera'