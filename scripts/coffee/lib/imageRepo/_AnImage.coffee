module.exports = class _AnImage

	constructor: (@_imageRepo, @url) ->

		@_gila = @_imageRepo._scene._gila

		@_texture = null

	getTexture: ->

		@_texture = @getATexture() unless @_texture?

		@_texture

	getATexture: (setParams = yes) ->

		@_texture = @_gila.makeImageTexture @_source

		@_imageRepo._setDefaultParamsOn @_texture if setParams

		@_texture