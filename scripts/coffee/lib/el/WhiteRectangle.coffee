_BasicElement = require './_BasicElement'
WhiteRectangleProgram = require '../program/WhiteRectangleProgram'

module.exports = class WhiteRectangle extends _BasicElement

	constructor: ->

		super

		@_program = null

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

		p.draw()

		return