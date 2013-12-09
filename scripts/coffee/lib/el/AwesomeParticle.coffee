_El = require '../_El'
painterRepo = require '../painter/awesomeParticlePainter/repo'
classic = require 'utila/scripts/js/lib/classic'
Api_ = require './awesomeParticle/Api_'

module.exports = classic.mix Api_, class AwesomeParticle extends _El

	@create: (sceneOrEl, flags) ->

		index = painterRepo.getIndexForFlags flags

		AwesomeParticlePool.get sceneOrEl, flags, index

	@take: (el) ->

		AwesomeParticlePool.take el

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

AwesomeParticlePool = require './awesomeParticle/AwesomeParticlePool'

