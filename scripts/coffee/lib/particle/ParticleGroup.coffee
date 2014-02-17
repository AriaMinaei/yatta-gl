ParticleApi_ = require './particleElement/ParticleApi_'

module.exports = class ParticleGroup

	constructor: ->

		@particles = []

	push: (p) ->

		@particles.push p

		@

for own fnName of ParticleApi_::

	continue if fnName[0] is '_' or fnName.match /^get/

	do (fnName) ->

		ParticleGroup::[fnName] = ->

			for p in @particles

				p[fnName].apply p, arguments

			return