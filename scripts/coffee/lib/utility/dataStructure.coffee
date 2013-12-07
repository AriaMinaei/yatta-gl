module.exports.makeArray = (obj, type) ->

	size = 0

	for i in [3..arguments.length] by 2

		size += arguments[i]

	a = new type size

	index = 0

	for i in [3..arguments.length] by 2

		size = arguments[i]
		name = arguments[i - 1]

		obj[name] = a.subarray index, (index += size)

	a