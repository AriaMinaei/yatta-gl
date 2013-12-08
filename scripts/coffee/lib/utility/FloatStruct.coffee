object = require 'utila/scripts/js/lib/object'

module.exports = class FloatStruct

	constructor: ->

		@_floats = {}

		@_bytes = {}

		@_unsignedBytes = {}

		@_shorts = {}

		@_unsignedShorts = {}

		@_normalized = {}

		@_prepared = no

		@_elements = []

		@_stride = 0

	_add: (place, name, size, normalized = no) ->

		@[place][name] = parseInt size

		@_normalized[name] = Boolean normalized

		@

	float: (name, size) ->

		@_add '_floats', name, size

	byte: (name, size, normalized) ->

		@_add '_bytes', name, size, normalized

	unsignedByte: (name, size, normalized) ->

		@_add '_unsignedBytes', name, size, normalized

	short: (name, size, normalized) ->

		@_add '_shorts', name, size, normalized

	unsignedShort: (name, size, normalized) ->

		@_add '_unsignedShorts', name, size, normalized

	_addEl: (glType, jsType, name, size, len, normalized, offset) ->

		@_elements.push

			glType: glType

			jsType: jsType

			name: name

			size: size

			len: len

			normalized: normalized

			offset: offset

		return

	_prepare: ->

		return if @_prepared

		@_prepared = yes

		offset = 0

		# Floats

		for name, size of @_floats

			@_addEl FLOAT, Float32Array,

				name, size, (len = size * 4), no, offset

			offset += len

		# shorts

		for name, size of @_shorts

			@_addEl SHORT, Int16Array,

				name, size, (len = size * 2), @_normalized[name]?, offset

			offset += len

		# unsigned shorts

		for name, size of @_unsignedShorts

			@_addEl UNSIGNED_SHORT, Uint16Array,

				name, size, (len = size * 2), @_normalized[name]?, offset

			offset += len

		# bytes

		for name, size of @_bytes

			@_addEl BYTE, Int8Array,

				name, size, (len = size * 1), @_normalized[name]?, offset

			offset += len

		# unsigned bytes

		for name, size of @_unsignedBytes

			@_addEl UNSIGNED_BYTE, Uint8Array,

				name, size, (len = size * 1), @_normalized[name]?, offset

			offset += len

		offset = makeNumberMultipleOf offset, 4

		@_stride = offset

	makeParamHolder: (base) ->

		do @_prepare

		params = if base? then object.clone base else {}

		params.__buffer = buffer = new ArrayBuffer @_stride

		for el in @_elements

			params[el.name] = new el.jsType buffer, el.offset, el.size

		params

	getElements: ->

		do @_prepare

		@_elements

	getStride: ->

		do @_prepare

		@_stride

makeNumberMultipleOf = (n, k) ->

	Math.ceil(n / k) * k

empty = (o) -> Object.keys(o).length is 0

{FLOAT, BYTE, UNSIGNED_BYTE, SHORT, UNSIGNED_SHORT} = WebGLRenderingContext