_Painter = require '../_Painter'

{vert, frag} = require './particlePainter/shaders'

module.exports = class ParticlePainter extends _Painter

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

		@_program = @_gila.makeProgram vert, frag, 'particleProgram'

		@_program.activate()

		@_props =

			dims: new Float32Array 2

			transformation: null

			perspective: null

			shouldUpdatePerspective: yes

			lastPerspectiveUploadTime: -1

			texture: null

			textureFillChannel: 0

		@_vx =

			attr: @_program.attr 'vx'

			buffer: @_gila.makeArrayBuffer()

		@_vx.attr.enable()

		@_vx.buffer.data self._vertices

		@_uniforms =

			dims: @_program.uniform '2f', 'uDims'

			trans: @_program.uniform 'mat4', 'uTrans'

			pers: @_program.uniform 'mat4', 'uPers'

			textureSlot: @_program.uniform '1i', 'textureSlot'

			textureFillChannel: @_program.uniform '1i', 'textureFillChannel'

	setDims: (dimsArray) ->

		@_props.dims[0] = dimsArray[0]

		@_props.dims[1] = dimsArray[1]

		@

	setTransformation: (t) ->

		@_props.transformation = t

		@

	setPerspective: (p) ->

		if p is @_props.perspective

			if not p.lastUpdateTime? or p.lastUpdateTime > @_props.lastPerspectiveUploadTime

				@_props.shouldUpdatePerspective = yes

			return @

		@_props.perspective = p

		@_props.shouldUpdatePerspective = yes

		@

	setTexture: (texture, channel) ->

		@_props.texture = texture

		@_props.textureFillChannel = channel

		@

	_reset: ->

		@setDims 0, 0

		@setTransformation null

		@_props.texture = null

		@_props.textureFillChannel = 3

		return

	_activate: ->

		@_program.activate()

		return

	_setPerspectiveUniform: ->

		if @_props.shouldUpdatePerspective

			@_props.lastPerspectiveUploadTime = @_getTickNumber()

			@_uniforms.pers.set @_props.perspective

		@_props.shouldUpdatePerspective = no

		return

	_setTextureUniforms: ->

		unless @_props.texture?

			throw Error "no texture!"

		@_props.texture.assignToSlot 0

		@_uniforms.textureSlot.set 0

		@_uniforms.textureFillChannel.set @_props.textureFillChannel

		return

	_setUniforms: ->

		@_uniforms.dims.fromArray @_props.dims

		@_uniforms.trans.set @_props.transformation

		do @_setPerspectiveUniform

		do @_setTextureUniforms

		return

	_drawVertices: ->

		@_vx.buffer.bind()

		@_vx.attr.readAsFloat 3, no, 0, 0

		@_gila.drawTriangles 0, 6

	paint: ->

		do @_activate

		do @_setUniforms

		do @_drawVertices

		do @_reset

		@