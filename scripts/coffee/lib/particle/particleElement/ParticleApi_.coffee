module.exports = class ParticleApi_

	size: (x) ->

		@_params.size[0] = x

		@

	getSize: ->

		@_params.size[0]

	moveXTo: (x) ->

		@_params.pos[0] = x

		@

	moveX: (x) ->

		@_params.pos[0] += x

		@

	moveYTo: (y) ->

		@_params.pos[1] = y

		@

	moveY: (y) ->

		@_params.pos[1] += y

		@

	moveZTo: (z) ->

		@_params.pos[2] = z

		@

	moveZ: (z) ->

		@_params.pos[2] += z

		@

	getMovement: ->

		@_params.pos

	moveTo: (x, y, z) ->

		@_params.pos[0] = x
		@_params.pos[1] = y
		@_params.pos[2] = z

		@

	move: (x, y, z) ->

		@_params.pos[0] += x
		@_params.pos[1] += y
		@_params.pos[2] += z

		@

	rotateZTo: (z) ->

		@_params.zRotation[0] = z

		@

	rotateZ: (z) ->

		@_params.zRotation[0] += z

		@

	getZRotation: ->

		@_params.zRotation[0]

	setVelocity: (x, y) ->

		@_params.velocity[0] = x
		@_params.velocity[1] = y

		@

	getVelocity: ->

		@_params.velocity

	color: (r, g, b, a = 1) ->


		@_params.color[0] = r * 255
		@_params.color[1] = g * 255
		@_params.color[2] = b * 255
		@_params.color[3] = a * 255

		@

	getColor: ->

		@_params.color

	opacity: (o) ->

		@_params.opacity[0] = o

		@

	getOpacity: ->

		@_params.opacity[0]

	fillWithImage: (image) ->

		@_painter.updateFillWithImage @_params, image

		@

	maskOnFixedImage: (image) ->

		@_painter.updateMaskOnFixedImage @_params, image

		@

	maskWithImage: (image, channel = 4) ->

		@_painter.updateMaskWithImage @_params, image, channel

		@

	maskWithFixedImage: (image, channel = 4) ->

		@_painter.updateMaskWithFixedImage @_params, image, channel

		@

	tint: (r, g, b, intensity) ->

		@_params.tint[0] = r
		@_params.tint[1] = g
		@_params.tint[2] = b
		@_params.tint[3] = intensity

		@

	_enable: ->

		@_params.enabled[0] = 1

		@

	_disable: ->

		@_params.enabled[0] = 0

		@