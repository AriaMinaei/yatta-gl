ImageRepo = require './ImageRepo'
Timing = require 'raf-timing'
Layer = require './Layer'
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

		@_clearColor = new Float32Array [0, 0, 0, 1]

		@_setCanvas idOrCanvas

		do @_initTiming

		@images = new ImageRepo @

		@_layers = []

		@_layerRenderingInstructions = []

		@_frameBuffers = []

	addLayer: (name) ->

		l = new Layer @, name

		@_layers.push l

		do @_resetRenderingInstructions

		l

	_resetRenderingInstructions: ->

		inst = @_layerRenderingInstructions

		inst.length = 0

		if @_layers.length is 1

			return inst.push null

		if @_layers.length is 2

			if @_frameBuffers.length is 0

				@_frameBuffers.push @_gila.makeFrameBuffer()

		return

	_initTiming: ->

		@_boundTick = (t) =>

			@_tick t

			return

		@timing = new Timing

		@_rafId = Timing.requestAnimationFrame @_boundTick

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

		do @_redraw

		return

	_redraw: ->

		for l, i in @_layers

			instruction = @_layerRenderingInstructions[i]

			unless instruction?

				l._redraw()

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

		do @_applyClearColor

		return

	bg: (r, g, b, a = 1) ->

		@_clearColor[0] = r
		@_clearColor[1] = g
		@_clearColor[2] = b
		@_clearColor[3] = a

		do @_applyClearColor

		@

	_applyClearColor: ->

		@_gila.setClearColor @_clearColor[0], @_clearColor[1],

			@_clearColor[2], @_clearColor[3]

		return