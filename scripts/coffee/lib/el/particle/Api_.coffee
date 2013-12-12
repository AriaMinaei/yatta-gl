module.exports = class Api_

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

		@

	moveTo: (x, y, z) ->

		@_params.pos[0] = x
		@_params.pos[1] = y
		@_params.pos[2] = z

		@

	move: (x, y, to) ->

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

	color: (r, g, b, a) ->

		@_params.color[0] = r
		@_params.color[1] = g
		@_params.color[2] = b
		@_params.color[3] = a

		@

	getColor: ->

		@_params.color

	opacity: (o) ->

		@_params.opacity[0] = o

		@

	getOpacity: ->

		@_params.opacity[0]

	fillWithImage: (image) ->

		@_params.fillWithImageProps.image = String image

		@_params.fillWithImageProps.updated = yes

		@

	maskOnImage: (image) ->

		@_params.maskOnImageProps.image = String image

		@_params.maskOnImageProps.updated = yes

		@

	maskWithImage: (image, channel) ->

		@_params.maskWithImageProps.image = String image

		@_params.maskWithImageProps.channel = parseInt(channel) || 0

		@_params.maskWithImageProps.updated = yes

		@

	noBlend: ->

		@_params.blending = 0

		@

	blendAsTransparent: ->

		@_params.blending = 1

		@

	blendAsAdd: ->

		@_params.blending = 2

		@