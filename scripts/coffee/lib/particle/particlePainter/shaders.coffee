#133333333333333333333333333

macro read (node) ->

	macro.valToNode String macro.require('fs').readFileSync macro.nodeToVal node

module.exports.frag = read 'coffee/lib/particle/particlePainter/shaders/shader.frag'

module.exports.vert = read 'coffee/lib/particle/particlePainter/shaders/shader.vert'
