_El = require '../_El'
painterRepo = require '../painter/particlePainter/repo'
classic = require 'utila/scripts/js/lib/classic'
Api_ = require './particle/Api_'

module.exports = classic.mix Api_, class Particle extends _El

	@create: (sceneOrEl, flags) ->

		index = painterRepo.getIndexForFlags flags

		ParticlePool.get sceneOrEl, flags, index

	@take: (el) ->

		ParticlePool.take el

		return

	constructor: (sceneOrEl, flags, index) ->

		super

		@_init flags, index

	quit: ->

		super

		self.take @

		return

	_respondToParentChange: ->

		return

	_init: (@_flags, @_index) ->

		@_painter = painterRepo.get @_scene, @_flags, @_index

		@_params = @_painter.makeParamHolder()

		return

	_redraw: ->

		p = @_painter

		p.paint @_params

		return

ParticlePool = require './particle/ParticlePool'

