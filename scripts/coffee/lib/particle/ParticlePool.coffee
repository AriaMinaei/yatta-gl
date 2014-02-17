ParticleElement = require './ParticleElement'
ParticlePainter = require './ParticlePainter'
ParticleGroup = require './ParticleGroup'
_Pool = require '../_Pool'

module.exports = class ParticlePool extends _Pool

	self = @

	constructor: (scene, @count, @flags) ->

		super

		@_allElements = []

		@_remainingElements = []

		@_left = @count

		@_paramHolders = []

		@painter = new ParticlePainter @_scene, @flags, @count

		@_prepared = no

	_prepare: ->

		@_prepared = yes

		@_paramHolders = @painter.getParamHolders()

		for i in [0...@count]

			el = new ParticleElement @_scene, @, @painter, @_paramHolders[i], @flags

			@_allElements.push el
			@_remainingElements.push el

		return

	take: (el) ->

		el._disable()

		@_remainingElements.push el

		@_left++

		@

	get: ->

		do @_prepare unless @_prepared

		if @_left is 0

			throw Error "All elements in the pool are already in use"

		@_left--

		el = @_remainingElements.shift()

		el._enable()

		el

	getRest: ->

		do @_prepare unless @_prepared

		loop

			break if @_left is 0

			@get()

	replacePositionData: (newData) ->

		@painter.replacePositionData newData

		@

	getBuffers: ->

		do @_prepare unless @_prepared

		@_paramHolders.__buffers

	_redraw: ->

		do @_prepare unless @_prepared

		@painter.paint @_paramHolders, @count

		return

	@Group: ParticleGroup