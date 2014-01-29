_AnImage = require './_AnImage'

module.exports = class SingleImage extends _AnImage

	constructor: (imageRepo, url) ->

		super

		@_source = url

	inAtlas: no