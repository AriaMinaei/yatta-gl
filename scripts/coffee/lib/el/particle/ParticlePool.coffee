_Pool = require '../../_Pool'

module.exports = class ParticlePool extends _Pool

	self = @

	@makePool: (scene, count, flags) ->

		new self scene, count, flags

	constructor: (@_scene, @count, @flags) ->

		super

		@_index = painterRepo.getIndexForFlags @flags

		@_allElements = []

		@_remainingElements = []

		@_left = @count

		@_requestsForPaint = 0

		do @_prepare

	_prepare: ->

		@_painter = painterRepo.get @_scene, @flags, @_index

		@_paramHolders = @_painter.makeParamHolders @count

		for i in [0...@count]

			el = new Particle @_scene, @, @_paramHolders[i], @flags, @_index

			@_allElements.push el
			@_remainingElements.push el

		return

	take: (el) ->

		el._disable()

		@_remainingElements.push el

		@_left++

		@

	get: ->

		if @_left is 0

			throw Error "All elements in the pool are already in use"

		@_left--

		el = @_remainingElements.pop()

		el._enable()

		el

	paint: ->

		@_requestsForPaint++

		if @_requestsForPaint is @count - @_left

			@_requestsForPaint = 0

			do @_paint

		return

	_paint: ->

		@_painter.paint @_paramHolders

		return

painterRepo = require '../../painter/particlePainter/repo'
Particle = require '../Particle'