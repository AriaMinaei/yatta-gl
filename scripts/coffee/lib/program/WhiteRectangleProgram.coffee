_Program = require '../_Program'

vert = """
attribute vec3 vx;

uniform vec2 uDims;

uniform mat4 uTrans;

uniform mat4 uPers;

void main(void) {
	gl_Position = uPers * uTrans * (vec4(vx, 1) * vec4(uDims, 1, 1)); // * vec4(0.5, 1, 1, 1);
	//gl_Position = uTrans * vec4(vx, 1);
}
"""

frag = """
precision mediump float;

void main() {
	gl_FragColor = vec4(1.0, 1.0, 1.0, 1.0);
}
"""

module.exports = class WhiteRectangleProgram extends _Program

	self = @

	# Here, programs aren't limited to webgl programs, and come
	# with predefined shapes and geometries, among other things.
	@_vertices: new Float32Array [
		-1, -1, 0,
		-1,  1, 0,
		 1, -1, 0,

		 1, -1, 0,
		-1,  1, 0,
		 1,  1, 0
	]

	_init: ->

		@_dims = new Float32Array 2

		@_transformation = null

		@_perspective = null

		@_shouldUpdatePerspective = yes

		@_lastPerspectiveUploadTime = -1

		@_program = @_gila.makeProgram vert, frag, 'whiteRectangleProgram'

		@_program.activate()

		@_vxAttr = @_program.attr 'vx'

		@_vxAttr.enable()

		@_vxBuffer = @_gila.makeArrayBuffer()

		@_vxBuffer.data self._vertices

		@_dimsUniform = @_program.uniform '2f', 'uDims'

		@_transUniform = @_program.uniform 'mat4', 'uTrans'

		@_persUniform = @_program.uniform 'mat4', 'uPers'

	setDims: (dimsArray) ->

		@_dims[0] = dimsArray[0]

		@_dims[1] = dimsArray[1]

		@

	setTransformation: (t) ->

		@_transformation = t

		@

	setPerspective: (p) ->

		if p is @_perspective

			if not p.lastUpdateTime? or p.lastUpdateTime > @_lastPerspectiveUploadTime

				@_shouldUpdatePerspective = yes

			return @

		@_perspective = p

		@_shouldUpdatePerspective = yes

		@

	_reset: ->

		@setDims 0, 0

		@setTransformation null

		return

	_activate: ->

		@_program.activate()

		return

	_uploadPerspective: ->

		if @_shouldUpdatePerspective

			@_lastPerspectiveUploadTime = @_getTickNumber()

			@_persUniform.set @_perspective

		@_shouldUpdatePerspective = no

		return

	draw: ->

		do @_activate

		@_dimsUniform.fromArray @_dims

		@_transUniform.set @_transformation

		do @_uploadPerspective

		@_vxBuffer.bind()

		@_vxAttr.readAsFloat 3, no, 0, 0

		@_gila.drawTriangles 0, 6

		do @_reset

		@