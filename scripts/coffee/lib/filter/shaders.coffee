##########

macro read (node) ->

	macro.valToNode macro.require('e:/open-source/black-sugar').concat macro.nodeToVal node

module.exports.vert = read 'coffee/lib/filter/shaders/shader.vert'