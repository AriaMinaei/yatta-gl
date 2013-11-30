_BasicElement = require './_BasicElement'
WhiteRectangleProgram = require '../program/WhiteRectangleProgram'
Dims2D = require './property/Dims2D'

module.exports = class WhiteRectangle extends _BasicElement

	constructor: ->

		super

		@_dims = new Dims2D

		@_program = null

		@_texture = null

	_getProgram: ->

		unless @_program?

			@_program = new WhiteRectangleProgram @

		@_program

	_respondToParentChange: ->

		do @_resetProgram

		return

	_resetProgram: ->

		@_program = null

		do @_getProgram

	_getTexture: ->

		unless @_texture?

			@_texture = @_scene._textureRepo.get './gloop.png'

		return @_texture

	_redraw: ->

		p = @_getProgram()

		p.setDims @_dims.getDims()

		p.setTransformation @_transformation.getMatrix()

		p.setPerspective @_getCameraPerspective()

		p.useTexture @_getTexture()

		p.draw()

		super

		return

	@_methodsToExpose: [Dims2D._methodsToExpose]