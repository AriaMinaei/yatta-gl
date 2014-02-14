Esterakt = require 'esterakt'
shaders = require './ParticlePainter/shaders'
_Emitter = require '../utility/_Emitter'

_programCount = 0

module.exports = class ParticlePainter extends _Emitter

	constructor: (@_scene, @flags, @_count) ->

		super

		@_gila = @_scene._gila

		@_currentBlending = -1

		@_imageAtlasTexture = null

		@_pictureAtlasTexture = null

		@_useVao = @_gila.extensions.vao.isAvailable()

		unless @_useVao

			throw Error "Currently, we need OES_vertex_array_object extension to work"

		else

			@_vao = @_gila.extensions.vao.create()

		@_shouldInit = yes

	_init: ->

		@_shouldInit = no

		do @_initDataStructure

		do @_initParamHolders

		do @_initProgram

	_initProgram: ->

		@_vao.bind()

		flagsInCaps = {}

		@_programId = _programCount++

		for key, val of @flags

			flagsInCaps[key.toUpperCase()] = val

		{vertSource, fragSource} = @_getShadersSource()

		vert = @_gila.getVertexShader "particle-#{@_programId}-vert",

			vertSource, flagsInCaps

		frag = @_gila.getFragmentShader "particle-#{@_programId}-frag",

			fragSource, flagsInCaps

		@_program = @_gila.getProgram vert, frag

		do @_initUniforms

		do @_initAttribs

		@_emit 'init-program'

		@_vao.unbind()

		return

	_getShadersSource: ->

		modofiers =

			vert:

				head: ""
				prependBody: ""
				appendBody: ""

			frag:

				head: ""
				prependBody: ""
				appendBody: ""

		@_emit "init-shaders", modofiers

		vertSource = shaders.vert
		.replace(/\[\[head\]\]/, modofiers.vert.head)
		.replace(/\[\[body-top\]\]/, modofiers.vert.prependBody)
		.replace(/\[\[body-bottom\]\]/, modofiers.vert.appendBody)

		fragSource = shaders.frag
		.replace(/\[\[head\]\]/, modofiers.frag.head)
		.replace(/\[\[body-top\]\]/, modofiers.frag.prependBody)
		.replace(/\[\[body-bottom\]\]/, modofiers.frag.appendBody)

		{vertSource, fragSource}

	_initUniforms: ->

		@_program.activate()

		@_uniforms =

			win: @_program.uniform('2f', 'win')
			.set(@_scene._dims.perceivedWidth, @_scene._dims.perceivedHeight)

		if @flags.fillWithImage

			@_uniforms.imageAtlasUnit = @_program.uniform '1i', 'imageAtlasUnit'

		else if @flags.maskOnFixedImage

			@_uniforms.pictureAtlasUnit = @_program.uniform '1i', 'pictureAtlasUnit'

		if @flags.maskWithImage or @flags.maskWithFixedImage

			@_uniforms.imageAtlasUnit = @_program.uniform '1i', 'imageAtlasUnit'

		@_emit 'init-uniforms'

		return

	_initDataStructure: ->

		@_baseParams = {}

		flags = @flags

		@_struct = new Esterakt

		@_struct.getContainer('pos').float 'pos', 3

		container = @_struct.getContainer()

		container.float 'size', 1, [1]

		container.float 'opacity', 1, [1]

		container.short 'enabled', 1, [1]

		if flags.tint

			container.float 'tint', 4

		switch flags.blending

			when no

				@_blendingMode = 0

			when yes

				@_blendingMode = 1

			when 'transparent'

				@_blendingMode = 1

			when 'add'

				@_blendingMode = 2

			else

				@_blendingMode = 0

		if flags.fillWithImage

			# These will be set in the element api
			@_baseParams.fillWithImageProps = image: null

			# The attribute to the coordinates of the image in the atlas
			container.float 'fillWithImageCoords', 4

		else if flags.maskOnFixedImage

			# These will be set in the element api
			@_baseParams.maskOnFixedImageProps = image: null

			# The attribute to the coordinates of the image in the atlas
			container.float 'maskOnFixedImageCoords', 4

		else

			container.unsignedByte 'color', 4, [255, 255, 255, 255], yes

		if flags.maskWithImage

			# These will be set in the element api
			@_baseParams.maskWithImageProps = image: null, channel: 0

			# The attribute to the coordinates of the image in the atlas
			container.float 'maskWithImageCoords', 4

			# The attribute to specify which color channel should be used for the mask
			container.float 'maskWithImageChannel', 1

		if flags.maskWithFixedImage

			# These will be set in the element api
			@_baseParams.maskWithFixedImageProps = image: null, channel: 0

			# The attribute to the coordinates of the image in the atlas
			container.float 'maskWithFixedImageCoords', 4

			# The attribute to specify which color channel should be used for the mask
			container.float 'maskWithFixedImageChannel', 1

		if flags.zRotation

			container.float 'zRotation', 1

		if flags.motionBlur

			container.float 'velocity', 2

		@_emit 'init-dataStructure'

	_initParamHolders: ->

		@_holders = @_struct.makeParamHolders @_baseParams, @_count

		@_uint8ViewOfPositionData = @_holders.__uint8Views.pos

		@_emit 'init-paramHolders'

		return

	_initAttribs: ->

		@_buffers = {}

		@_program.activate()

		for name, container of @_struct.getContainers()

			@_buffers[name] = buffer = {}

			buffer.glBuffer = @_gila.makeArrayBuffer().bind()

			buffer.data = @_holders.__buffers[name]

			stride = container.getStride()

			for el in container.getElements()

				@_program.attr(el.name).enable()._pointer el.size,

					el.glType, el.normalized, stride, el.offset

		return

	replacePositionData: (newData) ->

		@_uint8ViewOfPositionData.set newData

		return

	getParamHolders: ->

		do @_init if @_shouldInit

		@_holders

	_prepareImageAtlasTexture: (image) ->

		return if @_imageAtlasTexture?

		@_program.activate()

		@_imageAtlasTexture = image.getTexture()

		unit = @_imageAtlasTexture.assignToAUnit()

		@_uniforms.imageAtlasUnit.set unit

		return

	_preparePictureAtlasTexture: (image) ->

		return if @_pictureAtlasTexture?

		@_program.activate()

		@_pictureAtlasTexture = image.getTexture()

		unit = @_pictureAtlasTexture.assignToAUnit()

		@_uniforms.pictureAtlasUnit.set unit

		return

	_applyBlending: ->

		if @_blendingMode is 0

			@_gila.blending.disable()

			return

		@_gila.blending.enable()

		switch @_blendingMode

			when 1

				@_gila.blend
				.src.srcAlpha()
				.dst.oneMinusSrcAlpha()
				.update()

			when 2

				@_gila.blend
				.src.srcAlpha()
				.dst.one()
				.update()

		return

	updateFillWithImage: (holder, image) ->

		holder.fillWithImageProps.image = image

		# get atlas data of the element's image
		image = @_scene.images.atlases.getImageData image

		# prepare the atls texture, if it's not already
		@_prepareImageAtlasTexture image.atlasUrl

		# the shader needs to know the coordinates of the image
		# in the shader atlas
		holder.fillWithImageCoords.set image.coords

		return

	updateMaskOnFixedImage: (holder, url) ->

		holder.maskOnFixedImageProps.image = url

		# get atlas data of the element's image
		image = @_scene.images.get url

		unless image.inAtlas

			throw Error "All images associated with particles must be in an atlas"

		# prepare the atls texture, if it's not already
		@_preparePictureAtlasTexture image

		# the shader needs to know the coordinates of the image
		# in the shader atlas
		holder.maskOnFixedImageCoords.set image.coords

		return

	updateMaskWithImage: (holder, url, channel) ->

		holder.maskWithImageProps.image = url

		channel = parseInt(channel) || 0

		holder.maskWithImageProps.channel = channel

		# get atlas data of the element's image
		image = @_scene.images.get url

		unless image.inAtlas

			throw Error "All images associated with particles must be in an atlas"

		# prepare the atls texture, if it's not already
		@_prepareImageAtlasTexture image

		# the shader needs to know the coordinates of the image
		# in the shader atlas
		holder.maskWithImageCoords.set image.coords

		holder.maskWithImageChannel[0] = channel

		return

	updateMaskWithFixedImage: (holder, url, channel) ->

		holder.maskWithFixedImageProps.image = url

		channel = parseInt(channel) || 0

		holder.maskWithFixedImageProps.channel = channel

		# get atlas data of the element's image
		image = @_scene.images.get url

		unless image.inAtlas

			throw Error "All images associated with particles must be in an atlas"

		# prepare the atls texture, if it's not already
		@_prepareImageAtlasTexture image

		# the shader needs to know the coordinates of the image
		# in the shader atlas
		holder.maskWithFixedImageCoords.set image.coords

		holder.maskWithFixedImageChannel[0] = channel

		return

	_wireBuffers: ->

		for name, buffer of @_buffers

			buffer.glBuffer.streamData buffer.data

		return

	paint: ->

		do @_init if @_shouldInit

		@_vao.bind()

		@_program.activate()

		@_emit 'paint'

		do @_wireBuffers

		do @_applyBlending

		@_gila.drawPoints 0, @_count

		@_vao.unbind()

		return

	@possibleFlags: [
		'fillWithImage'
		'maskWithImage'
		'maskOnFixedImage'
		'maskWithFixedImage'
		'tint'
		'blending'
		'zRotation'
		'motionBlur'
	]