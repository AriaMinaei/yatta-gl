dataStructure = require '../painter/awesomeParticlePainter/dataStructure'
_BasicElement = require './_BasicElement'
painterRepo = require '../painter/awesomeParticlePainter/repo'
classic = require 'utila/scripts/js/lib/classic'
Api_ = require './awesomeParticle/Api_'

module.exports = classic.mix Api_, class AwesomeParticle extends _BasicElement

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

		@_params = dataStructure.get @_flags

		@_painter = painterRepo.get @_scene, @_flags, @_index

		return

	_redraw: ->

		p = @_painter

		p.paint()

		return

AwesomeParticlePool = require './awesomeParticle/AwesomeParticlePool'

