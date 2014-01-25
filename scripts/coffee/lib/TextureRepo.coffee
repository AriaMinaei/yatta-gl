module.exports = class TextureRepo

	self = @

	@defaultTextureParamsSetter: (t) ->

		t
		.magnifyWithLinear()
		.minifyWithLinearMipmapLinear()
		.wrapSClampToEdge()
		.wrapTClampToEdge()

		return

	constructor: (@_scene) ->

		@_gila = @_scene._gila

		@_textures = {}

		@_setTextureParams = self.defaultTextureParamsSetter

	# This callback will be called every time a new texture is
	# initialized. It'll have the chance to set parameters on the
	# texture and get it ready.
	#
	# Example at TextureRepo.defaultTextureParamsSetter()
	setTextureParamSetter: (cb) ->

		unless typeof cb is 'function'

			throw Error "textureParamSetter must be a function"

		@_setTextureParams = cb

		@

	get: (source, id) ->

		unless id?

			if typeof source is 'string'

				id = source

			else if source instanceof HTMLImageElement

				id = source.src

				if typeof id isnt 'string' or id.length is 0

					throw Error "Image src is empty"

			else

				throw Error "Cannot determine texture id if source isn't a url or an image element with an src"

		unless @_textures[id]?

			@_textures[id] = @_gila.makeImageTexture source

			@_setTextureParams @_textures[id]

		@_textures[id]