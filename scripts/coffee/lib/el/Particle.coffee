_El = require '../_El'
painterRepo = require '../painter/particlePainter/repo'
classic = require 'utila/scripts/js/lib/classic'
Api_ = require './particle/Api_'

module.exports = classic.mix Api_, class Particle extends _El

	# @create: (sceneOrEl, flags) ->

	# 	index = painterRepo.getIndexForFlags flags

	# 	ParticlePool.get sceneOrEl, flags, index

	# @take: (el) ->

	# 	ParticlePool.take el

	# 	return

	@pool: (scene, count, flags) ->

		ParticlePool.makePool scene, count, flags

	constructor: (sceneOrEl, pool, params, flags, index) ->

		super

		@_init pool, params, flags, index

	_respondToParentChange: ->

		return

	_init: (@_pool, @_params, @_flags, @_index) ->

		return

	_redraw: ->

		@_pool.paint()

		return

ParticlePool = require './particle/ParticlePool'