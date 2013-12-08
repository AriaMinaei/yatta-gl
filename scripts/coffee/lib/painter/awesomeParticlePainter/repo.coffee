{flagsToIndex} = require 'gila'

module.exports.possibleFlags = possibleFlags = ['fillWithImage', 'maskOnImage']

module.exports.repo = repo = {}

module.exports.get = get = (scene, flags, index) ->

	index ?= getIndexForFlags flags

	painter = repo[index]

	unless painter?

		return repo[index] = new AwesomeParticlePainter scene, flags, index

	painter

module.exports.getIndexForFlags = getIndexForFlags = (flags) ->

	if flags? then flagsToIndex(possibleFlags, flags) else 0

AwesomeParticlePainter = require '../AwesomeParticlePainter'