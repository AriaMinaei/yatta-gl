WhiteRectanglePainter = require '../painter/WhiteRectanglePainter'
_BasicElement = require './_BasicElement'
Dims2D = require './property/Dims2D'

module.exports = class WhiteRectangle extends _BasicElement

	constructor: ->

		super

		@_dims = new Dims2D

		@_painter = null

		@_texture = null

	_getPainter: ->

		unless @_painter?

			@_painter = new WhiteRectanglePainter @

		@_painter

	_respondToParentChange: ->

		do @_resetProgram

		return

	_resetProgram: ->

		@_painter = null

		do @_getPainter

	_getTexture: ->

		unless @_texture?

			@_texture = @_scene._textureRepo.get './gloop.png'

		return @_texture

	_redraw: ->

		p = @_getPainter()

		p.setDims @_dims.getDims()

		p.setTransformation @_transformation.getMatrix()

		p.setPerspective @_getCameraPerspective()

		p.useTexture @_getTexture()

		p.paint()

		super

		return

	@_methodsToExpose: [Dims2D._methodsToExpose]