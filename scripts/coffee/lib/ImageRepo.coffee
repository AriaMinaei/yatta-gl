AtlasRepo = require './imageRepo/AtlasRepo'
SingleImage = require './imageRepo/SingleImage'
ImageInAtlas = require './imageRepo/ImageInAtlas'

module.exports = class ImageRepo

	self = @

	constructor: (@_scene) ->

		@_images = {}

		@atlases = new AtlasRepo

		@_setDefaultParamsOn = self.defaultParamsSetter

	addAtlas: ->

		@atlases.add.apply @atlases, arguments

		@

	get: (url) ->

		unless @_images[url]?

			if @atlases.imageExists url

				data = @atlases.getImageData url

				image = new ImageInAtlas @, url, data

			else

				image = new SingleImage @, url

			@_images[url] = image

		@_images[url]

	setDefaultParamsSetter: (cb) ->

		unless typeof cb is 'function'

			throw Error "textureParamSetter must be a function"

		@_setDefaultParamsOn = cb

		@

	@defaultParamsSetter: (t) ->

		t
		.magnifyWithLinear()
		.minifyWithLinearMipmapLinear()
		.wrapSClampToEdge()
		.wrapTClampToEdge()

		return