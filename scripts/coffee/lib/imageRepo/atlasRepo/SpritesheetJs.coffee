module.exports = class SpritesheetJs

	@getImages: (config) ->

		baseUrl = config.baseUrl ? ''

		url = baseUrl + config.meta.image

		atlasSize = new Uint16Array [config.meta.size.w, config.meta.size.h]

		images = {}

		for name, data of config.frames

			image = atlasUrl: url, atlasSize: atlasSize

			image.sizePx = new Uint16Array [data.sourceSize.w, data.sourceSize.h]

			image.posPx = new Uint16Array [data.frame.x, data.frame.y]

			# [topleft.x, topleft.y, width, height] relative to full size
			image.coords = new Float32Array [
				data.frame.x / atlasSize[0]
				data.frame.y / atlasSize[1]
				data.frame.w / atlasSize[0]
				data.frame.h / atlasSize[1]
			]

			images[name] = image

		images