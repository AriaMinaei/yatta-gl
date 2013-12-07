module.exports = class AwesomeParticlePool

	self = @

	@_scenes: []

	@get: (el, flags, index) ->

		indexesPool = self._scenes[el._scene.id]

		unless indexesPool?

			indexesPool = self._scenes[el._scene.id] = {}

		pool = indexesPool[index]

		unless pool?

			pool = indexesPool[index] = new self flags, index

		pool.get el

	@take: (el) ->

		self._scenes[el._scene.id][el._index].take el

	constructor: (@flags, @index) ->

		@flags ?= {}

		@_items = []

		@_len = 0

	get: (el) ->

		if @_len > 0

			@_len--

			return @_prepare @_items.pop().putIn el

		else

			return new AwesomeParticle el, @flags, @index

	take: (el) ->

		@_items.push el

		@_len++

		return

AwesomeParticle = require '../AwesomeParticle'