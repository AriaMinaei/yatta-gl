_Painter = require '../_Painter'

{vert, frag} = require './whiteRectanglePainter/shaders'

module.exports = class WhiteRectanglePainter extends _Painter

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

		@_hasTexture = no

		@_texture = null

		@_program = @_gila.makeProgram vert, frag, 'whiteRectangleProgram'

		@_program.activate()

		@_vxAttr = @_program.attr 'vx'

		@_vxAttr.enable()

		@_vxBuffer = @_gila.makeArrayBuffer()

		@_vxBuffer.data self._vertices

		@_dimsUniform = @_program.uniform '2f', 'uDims'

		@_transUniform = @_program.uniform 'mat4', 'uTrans'

		@_persUniform = @_program.uniform 'mat4', 'uPers'

		@_textureSlotUniform = @_program.uniform '1i', 'textureSlot'

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

		@_hasTexture = no

		@_texture = null

		return

	useTexture: (texture) ->

		@_hasTexture = yes

		@_texture = texture

		@

	_activate: ->

		@_program.activate()

		return

	_uploadPerspective: ->

		if @_shouldUpdatePerspective

			@_lastPerspectiveUploadTime = @_getTickNumber()

			@_persUniform.set @_perspective

		@_shouldUpdatePerspective = no

		return

	_setTextureUniforms: ->

		unless @_texture?

			throw Error "no texture!"

		@_texture.assignToSlot 0

		@_textureSlotUniform.set 0

		return

	paint: ->

		do @_activate

		@_dimsUniform.fromArray @_dims

		@_transUniform.set @_transformation

		do @_uploadPerspective

		do @_setTextureUniforms

		@_vxBuffer.bind()

		@_vxAttr.readAsFloat 3, no, 0, 0

		@_gila.drawTriangles 0, 6

		do @_reset

		@