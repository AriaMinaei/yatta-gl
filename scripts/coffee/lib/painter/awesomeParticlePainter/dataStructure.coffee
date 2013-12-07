{makeArray} = require '../../utility/dataStructure'

module.exports.get = getDataStructureForFlags = (flags) ->

	floatArgs[0] = structure = {}

	floatArgs.length = 8

	if flags.fillImage

		throw Error "fillImage not implemented yet"

	else if flags.maskOnImage

		throw Error "maskOnImage not implemented yet"

	else

		floatArgs.push 'color'

		floatArgs.push 4

	structure.floats = makeArray.apply null, floatArgs

	structure

floatArgs = [null, Float32Array, 'size', 1, 'pos', 3, 'zRotation', 1]