{flagsToIndex} = require 'gila'

module.exports.possibleFlags = possibleFlags = ['fillWithImage', 'maskWithImage', 'maskOnImage', 'tint', 'blending']

module.exports.repo = repo = {}

module.exports.get = get = (scene, flags, index) ->

	index ?= getIndexForFlags flags

	painter = repo[index]

	unless painter?

		return repo[index] = new ParticlePainter scene, flags, index

	painter

module.exports.getIndexForFlags = getIndexForFlags = (flags) ->

	if flags? then flagsToIndex(possibleFlags, flags) else 0

ParticlePainter = require '../ParticlePainter'