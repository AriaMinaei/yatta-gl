exposeMethods = require './utility/exposeMethods'
array = require 'utila/scripts/js/lib/array'

module.exports = class _El

	self = @

	constructor: (layerOrEl) ->

		exposeMethods @

		@_children = []

		@putIn layerOrEl

	putIn: (layerOrEl) ->

		layerOrEl._adopt @

		if layerOrEl instanceof _El

			@parent = layerOrEl

		else

			@parent = null

		@_layer = layerOrEl._layer

		@_scene = layerOrEl._scene

		@_timing = @_scene.timing

		@_gila = @_scene._gila

		do @_respondToParentChange

		@

	quit: ->

		p = @parent

		if p?

			p._notYourChildAnymore @

		for child in @_children

			child.quit()

		return

	_notYourChildAnymore: (el) ->

		array.pluckItem @_children, el

		return

	_adopt: (el) ->

		do @_scheduleRedraw

		@_children.push el

		return

	# This gets called when element is put inside another element
	_respondToParentChange: ->

		throw Error 'Any class extending _El must respond to parent change in some way'

	_redraw: ->

		throw Error "Element has not implemented _redraw()"

	_scheduleRedraw: ->

		if @_scene? then do @_scene._scheduleRedraw

		return

	_getTickNumber: ->

		return @_timing.tickNumber if @_timing?

		return 0

	hasParent: ->

		@parent?