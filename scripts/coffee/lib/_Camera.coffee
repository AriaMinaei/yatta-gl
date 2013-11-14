_El = require './_El'
{mat4} = require 'gl-matrix'

module.exports = class _Camera extends _El

	constructor: ->

		@_shouldUpdateMatrix = yes

		@_perspectiveMatrix = mat4.create()

		@_shouldAutoSetProps = yes

	_respondToParentChange: ->

		throw Error "Classes extending _Camera *must* respond to parent change
			by at least reseting the aspect ratio."