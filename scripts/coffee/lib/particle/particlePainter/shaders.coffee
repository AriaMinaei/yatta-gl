#################

macro read (node) ->

	macro.valToNode macro.require('e:/open-source/black-sugar').concat macro.nodeToVal node

module.exports.frag = read 'coffee/lib/particle/particlePainter/shaders/shader.frag'

module.exports.vert = read 'coffee/lib/particle/particlePainter/shaders/shader.vert'