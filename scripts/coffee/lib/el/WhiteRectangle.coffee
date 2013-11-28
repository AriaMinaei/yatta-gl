_BasicElement = require './_BasicElement'
WhiteRectangleProgram = require '../program/WhiteRectangleProgram'

module.exports = class WhiteRectangle extends _BasicElement

	constructor: ->

		super

		@_program = null

		@_transformation.api.move 0.1, 0, 0

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

	_redraw: ->

		p = @_getProgram()

		p.setDims 0.99, 0.1

		p.setTransformation @_transformation.getMatrix()

		p.draw()

		return

window.w = WhiteRectangle