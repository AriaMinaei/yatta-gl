Esterakt = require 'esterakt'
shaders = require './ParticlePainter/shaders'

module.exports = class ParticlePainter

	constructor: (@_scene, @flags, @_count) ->

		@_gila = @_scene._gila

		@_currentBlending = -1

		@_imageAtlasTexture = null

		@_pictureAtlasTexture = null

		@_useVao = @_gila.extensions.vao.isAvailable()

		unless @_useVao

			throw Error "Currently, we need OES_vertex_array_object extension to work"

		else

			@_vao = @_gila.extensions.vao.create()

			@_vao.bind()

		do @_initProgram

		do @_initUniforms

		do @_initDataStructure

		do @_initParamHolders

		do @_initAttribs

		@_vao.unbind()

	_initProgram: ->

		flagsInCaps = {}

		for key, val of @flags

			flagsInCaps[key.toUpperCase()] = val

		vert = @_gila.getVertexShader 'particle-shader-vert',

			shaders.vert, flagsInCaps

		frag = @_gila.getFragmentShader 'particle-shader-frag',

			shaders.frag, flagsInCaps

		@_program = @_gila.getProgram vert, frag

		return

	_initUniforms: ->

		@_program.activate()

		@_uniforms =

			win: @_program.uniform('2f', 'win')
			.set(@_scene._dims.perceivedWidth, @_scene._dims.perceivedHeight)

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

			# We should enable the atlas
			@_uniforms.imageAtlasUnit = @_program.uniform '1i', 'imageAtlasUnit'

		else if flags.maskOnImage

			# These will be set in the element api
			@_baseParams.maskOnImageProps = image: null

			# The attribute to the coordinates of the image in the atlas
			container.float 'maskOnImageCoords', 4

			# We should enable the atlas
			@_uniforms.pictureAtlasUnit = @_program.uniform '1i', 'pictureAtlasUnit'

		else

			container.unsignedByte 'color', 4, [255, 255, 255, 255], yes

		if flags.maskWithImage

			# These will be set in the element api
			@_baseParams.maskWithImageProps = image: null, channel: 0

			# The attribute to the coordinates of the image in the atlas
			container.float 'maskWithImageCoords', 4

			# The attribute to specify which color channel should be used for the mask
			container.float 'maskWithImageChannel', 1

			# We should enable the atlas
			@_uniforms.imageAtlasUnit = @_program.uniform '1i', 'imageAtlasUnit'

	_initParamHolders: ->

		@_holders = @_struct.makeParamHolders @_baseParams, @_count

		@_uint8ViewOfPositionData = @_holders.__uint8Views.pos

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

		@_holders

	_prepareImageAtlasTexture: (imageUrl) ->

		return if @_imageAtlasTexture?

		@_program.activate()

		@_imageAtlasTexture = @_scene._textureRepo.get imageUrl

		unit = @_imageAtlasTexture.assignToAUnit()

		@_uniforms.imageAtlasUnit.set unit

		return

	_preparePictureAtlasTexture: (imageUrl) ->

		return if @_pictureAtlasTexture?

		@_program.activate()

		@_pictureAtlasTexture = @_scene._textureRepo.get imageUrl

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
		image = @_scene.atlas.getImageData image

		# prepare the atls texture, if it's not already
		@_prepareImageAtlasTexture image.atlasUrl

		# the shader needs to know the coordinates of the image
		# in the shader atlas
		holder.fillWithImageCoords.set image.coords

		return

	updateMaskOnImage: (holder, image) ->

		holder.maskOnImageProps.image = image

		# get atlas data of the element's image
		image = @_scene.atlas.getImageData image

		# prepare the atls texture, if it's not already
		@_preparePictureAtlasTexture image.atlasUrl

		# the shader needs to know the coordinates of the image
		# in the shader atlas
		holder.maskOnImageCoords.set image.coords

		return

	updateMaskWithImage: (holder, image, channel) ->

		holder.maskWithImageProps.image = image

		channel = parseInt(channel) || 0

		holder.maskWithImageProps.channel = channel

		# get atlas data of the element's image
		image = @_scene.atlas.getImageData image

		# prepare the atls texture, if it's not already
		@_prepareImageAtlasTexture image.atlasUrl

		# the shader needs to know the coordinates of the image
		# in the shader atlas
		holder.maskWithImageCoords.set image.coords

		holder.maskWithImageChannel[0] = channel

		return

	_wireBuffers: ->

		for name, buffer of @_buffers

			buffer.glBuffer.streamData buffer.data

		return

	paint: ->

		@_vao.bind()

		@_program.activate()

		do @_wireBuffers

		do @_applyBlending

		@_gila.drawPoints 0, @_count

		@_vao.unbind()

		return

	@possibleFlags: ['fillWithImage', 'maskWithImage', 'maskOnImage', 'tint', 'blending']