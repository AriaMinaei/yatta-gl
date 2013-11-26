_Program = require '../_Program'

vert = """
attribute vec3 aVertexPosition;

uniform vec3 uFixSize;
uniform vec3 uFixPos;

//uniform vec3 uActualPos;

void main(void) {
	gl_Position = vec4(aVertexPosition, 1) * vec4(uFixSize, 1) + vec4(uFixPos, 0);
}
"""

frag = """
precision mediump float;

void main() {
	gl_FragColor = vec4(1.0, 1.0, 1.0, 1.0);
}
"""

module.exports = class DummyProgram extends _Program

	constructor: ->

		super

		@_width = 0
		@_height = 0

		@_screenWidth = @_scene._dims.perceivedWidth
		@_screenHeight = @_scene._dims.perceivedHeight

		@_x = 0
		@_y = 0

		@_program = @_gila.makeProgram vert, frag, 'dummy-program'

		do @_activate

		@_vertexPosisionAttr = @_program.attr 'aVertexPosition'

		@_vertexPosisionAttr.enable()

		@_vertexPositionBuffer = @_gila.makeBuffer()

		@_fixSizeUniform = @_program.uniform 'uFixSize'

		@_fixPosUniform = @_program.uniform 'uFixPos'

	setVertices: (v) ->

		do @_activate

		@_vertexPositionBuffer.data new Float32Array v

		@

	_activate: ->

		@_program.goInUse()

		return

	set: (prop, val) ->

		@['_' + prop] = Number val

		@

	draw: ->

		do @_activate

		fixSizeX = @_width / @_screenWidth
		fixSizeY = @_height / @_screenHeight
		fixSizeZ = 1

		@_fixSizeUniform.set3f fixSizeX, fixSizeY, fixSizeZ

		fixPosX = @_x / @_screenWidth * 2 - 1
		fixPosY = @_y / @_screenHeight * 2 - 1
		fixPosZ = 0

		@_fixPosUniform.set3f fixPosX, fixPosY, fixPosZ

		do @_vertexPositionBuffer.bind

		@_vertexPosisionAttr.readFromBuffer 3, 'FLOAT', no, 0, 0

		@_gila.drawArrays 'TRIANGLES', 0, 6