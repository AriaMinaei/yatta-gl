AwesomeParticlePainter = require '../painter/AwesomeParticlePainter'
_BasicElement = require './_BasicElement'

module.exports = class PointParticle extends _BasicElement

	constructor: (scene, options) ->

		super



	_redraw: ->

		p = @_painter

		p.paint()

		return