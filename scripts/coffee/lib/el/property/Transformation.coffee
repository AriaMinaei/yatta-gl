TransformationApi = require 'transformation'

module.exports = class Transformation

	constructor: (@el) ->

		@api = new TransformationApi