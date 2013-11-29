_El = require './_El'

module.exports = class _Camera extends _El

	_respondToParentChange: ->

		throw Error "Classes extending _Camera *must* respond to parent change
			by at least reseting the aspect ratio."

	_redraw: ->

		# Only redraw children
		child._redraw() for child in @_children

		return