_Painter = require '../_Painter'

{vert, frag} = require './pointParticlePainter/shaders'

module.exports = class PointParticlePainter extends _Painter

	self = @

	_init: ->

		@_program = @_gila.makeProgram vert, frag, 'particleProgram'

		@_program.activate()

		@_floats = new Float32Array 16

		@_ints = new Int32Array 16

		@_props =

			zRotation: @_floats.subarray 0, 1

			fillType: @_ints.subarray 0, 1

			fillColor: @_floats.subarray 1, 5

			texture: null

			maskTextureFillChannel: 0

		@_uniforms =

			fillType: @_program.uniform '1i', 'fillType'

			zRotation: @_program.uniform '1f', 'zRotation'

			fillColor: @_program.uniform '4f', 'fillColor'

			maskTextureSlot: @_program.uniform '1i', 'maskTextureSlot'

			maskTextureFillChannel: @_program.uniform '1i', 'maskTextureFillChannel'

	setTexture: (texture, channel) ->

		@_props.texture = texture

		@_props.maskTextureFillChannel = channel

		@

	fillWithColor: (r, g, b, a) ->

		@_props.fillType[0] = 0

		@_props.fillColor[0] = r
		@_props.fillColor[1] = g
		@_props.fillColor[2] = b
		@_props.fillColor[3] = a

		@

	_reset: ->


		@_props.texture = null

		@_props.maskTextureFillChannel = 3

		return

	_activate: ->

		@_program.activate()

		return

	_setTextureUniforms: ->

		@_props.texture.assignToSlot 0

		@_uniforms.maskTextureSlot.set 0

		@_uniforms.maskTextureFillChannel.set @_props.maskTextureFillChannel

		return

	_setUniforms: ->

		@_uniforms.zRotation.fromArray @_props.zRotation

		@_uniforms.fillColor.fromArray @_props.fillColor

		do @_setTextureUniforms

		return

	setZRotation: (z) ->

		@_props.zRotation[0] = z

		@

	_drawVertices: ->

		# @_vx.buffer.bind()

		# @_vx.attr.readAsFloat 3, no, 0, 0

		@_gila.drawPoints 0, 1

		return

	paint: ->

		do @_activate

		do @_setUniforms

		do @_drawVertices

		do @_reset

		@