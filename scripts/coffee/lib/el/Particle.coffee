ParticlePainter = require '../painter/ParticlePainter'
_BasicElement = require './_BasicElement'
Dims2D = require './property/Dims2D'

[RED, GREEN, BLUE, ALL] = [0, 1, 2, 3]

module.exports = class Particle extends _BasicElement

	constructor: (scene, textureSource, textureChannel) ->

		super

		@_dims = new Dims2D

		@_painter = null

		@_texture =

			object: null

			channel: null

			source: null

		@setTexture textureSource, textureChannel

	setTexture: (source, channel = ALL) ->

		unless source?

			throw Error "`texture source` must be a valid image/url"

		@_texture.source = source

		if @_gila.debug and channel not in [ALL, RED, GREEN, BLUE]

			throw Error "`channel` must be an integer either 0(red), 1(green), 2(blue), 3(all)"

		@_texture.channel = channel

		@_texture.object = @_scene._textureRepo.get @_texture.source

		@

	_getPainter: ->

		unless @_painter?

			@_painter = new ParticlePainter @

		@_painter

	_respondToParentChange: ->

		do @_resetProgram

		return

	_resetProgram: ->

		@_painter = null

		do @_getPainter

	_redraw: ->

		p = @_getPainter()

		p.setDims @_dims.getDims()

		p.setTransformation @_transformation.getMatrix()

		p.setPerspective @_getCameraPerspective()

		p.setTexture @_texture.object, @_texture.channel

		p.paint()

		do @_redrawChildren

		return

	@_methodsToExpose: [Dims2D._methodsToExpose]