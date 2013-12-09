#13333333333333333333333333333333

macro read (node) ->

	macro.valToNode String macro.require('fs').readFileSync macro.nodeToVal node

module.exports.frag = read 'shaders/AwesomeParticle/shader.frag'

module.exports.vert = read 'shaders/AwesomeParticle/shader.vert'
