_Painter = require '../_Painter'

# {vert, frag} = require './awesomeParticlePainter/shaders'

module.exports = class AwesomeParticlePainter extends _Painter

	self = @

	_init: (scene, @flags, @index) ->

	paint: (floats) ->

		console.log @index