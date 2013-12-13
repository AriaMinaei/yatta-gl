#1333333333333333333333333333333

macro read (node) ->

	macro.valToNode String macro.require('fs').readFileSync macro.nodeToVal node

module.exports.frag = read 'shaders/particle/shader.frag'

module.exports.vert = read 'shaders/particle/shader.vert'
