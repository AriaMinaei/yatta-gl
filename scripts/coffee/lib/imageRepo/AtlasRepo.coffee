SpritesheetJs = require './atlasRepo/SpritesheetJs'

module.exports = class AtlasRepo

	constructor: ->

		@_images = {}

		@_formats =

			'spritesheet-js': SpritesheetJs

	addFormat: (name, format) ->

		if @_formats[name]?

			throw Error "Format name `#{name}` is already recognized"

		@_formats[name] = format

		@

	add: (config, baseUrl = '', prefix = '', format = 'spritesheet-js') ->

		if String(baseUrl).length > 0

			config.baseUrl = baseUrl

		format = @_formats[format]

		unless format?

			throw Error "Unkown atlas format `#{format}`"

		for name, data of format.getImages config

			file = prefix + name

			if @_images[file]?

				throw Error "Image with filename `#{file}` already exists in the atlas repo"

			@_images[file] = data

		@

	getImageData: (file) ->

		@_images[file]

	imageExists: (file) ->

		@_images[file]?