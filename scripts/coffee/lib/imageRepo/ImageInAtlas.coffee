_AnImage = require './_AnImage'

module.exports = class ImageInAtlas extends _AnImage

	constructor: (imageRepo, url, @atlasData) ->

		super

		@_source = @atlasData.atlasUrl

		@coords = @atlasData.coords

	inAtlas: yes