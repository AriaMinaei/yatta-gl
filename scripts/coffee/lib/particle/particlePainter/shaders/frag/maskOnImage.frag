vec2 coordOnMask = vec2(
	clipCoord.x / 2.0 + 0.5,
	clipCoord.y / -2.0 + 0.5
);

vec4 fillColor = texture2D(

	pictureAtlasUnit,

	vec2(
		vMaskOnImageCoords[2] * coordOnMask.x + vMaskOnImageCoords[0],
		vMaskOnImageCoords[3] * coordOnMask.y + vMaskOnImageCoords[1]
	)
);