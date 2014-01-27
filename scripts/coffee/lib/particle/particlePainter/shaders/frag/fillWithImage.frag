vec4 fillColor = texture2D(

	imageAtlasUnit,

	vec2(
		vFillWithImageCoords[2] * pointCoord.x + vFillWithImageCoords[0],
		vFillWithImageCoords[3] * pointCoord.y + vFillWithImageCoords[1]
		)
	);