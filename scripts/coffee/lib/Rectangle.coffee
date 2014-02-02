shaders = require './rectangle/shaders'

rectangleVx = new Float32Array [
	-1, -1,
	-1,  1,
	 1, -1,

	 1, -1,
	-1,  1,
	 1,  1
]

module.exports = class Rectangle

	constructor: (@_layer, imageUrl) ->

		@_scene = @_layer._scene

		@_layer._adopt @

		@_gila = @_scene._gila

		image = @_scene.images.get(imageUrl)

		if image.inAtlas

			throw Error "Rectangle doesn't support in-atlas images yet"

		@imageTexture = image

			.getATexture(no)
			.wrapSClampToEdge()
			.wrapTClampToEdge()
			.magnifyWithLinear()
			.minifyWithLinear()
			.flipY()

		do @_initProgram

	_initProgram: ->

		# @_useVao = @_gila.extensions.vao.isAvailable()

		# unless @_useVao

		# 	throw Error "Currently, we need OES_vertex_array_object extension to work"

		# else

		# 	@_vao = @_gila.extensions.vao.create()

		# 	@_vao.bind()

		vert = @_gila.getVertexShader 'filter-rectangle-vert', shaders.vert

		frag = @_gila.getFragmentShader 'filter-rectangle-frag', shaders.frag

		@_program = @_gila.getProgram vert, frag

		@_imageUniform = @_program.uniform '1i', 'image'

		@_gila.makeArrayBuffer().staticData rectangleVx

		@_program.attr('vx').enable().readAsFloat 2, no, 8, 0

		# @_vao.unbind()

	_redraw: ->

		# @_vao.bind()

		@_program.activate()

		@_imageUniform.set @imageTexture.assignToAUnit()

		@_gila.drawTriangles 0, 6

		# @_vao.unbind()