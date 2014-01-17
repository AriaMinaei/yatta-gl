ParticleApi_ = require './particleElement/ParticleApi_'
classic = require 'utila/scripts/js/lib/classic'

module.exports = classic.mix ParticleApi_, class ParticleElement

	constructor: (@_scene, @_pool, @_painter, @_params, @_flags) ->

	copyFrom: (otherEl) ->

		for name, prop of @_params

			if prop.set?

				prop.set otherEl._params[name]

		return