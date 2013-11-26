_El = require '../_El'
DummyProgram = require '../program/DummyProgram'

module.exports = class Dummy extends _El

	constructor: ->

		super

		@_vertices = [
			-1, -1, 0,
			-1,  1, 0,
			 1, -1, 0,

			 1, -1, 0,
			-1,  1, 0,
			 1,  1, 0
		]

	_redraw: ->

		p = @_getProgram()

		p.set 'width', 20
		p.set 'height', 20

		p.set 'x', 300
		p.set 'y', 100

		p.setVertices @_vertices

		p.draw()


	_getProgram: ->

		unless @_program?

			@_program = new DummyProgram @

		@_program

	_respondToParentChange: ->

		do @_resetProgram

		return

	_resetProgram: ->

		@_program = new DummyProgram @