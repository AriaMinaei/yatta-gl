vec2 coordOnMask = vec2(
	clipCoord.x / 2.0 + 0.5,
	clipCoord.y / -2.0 + 0.5
);

vec4 fillColor = texture2D(

	pictureAtlasUnit,

	vec2(
		vMaskOnFixedImageCoords[2] * coordOnMask.x + vMaskOnFixedImageCoords[0],
		vMaskOnFixedImageCoords[3] * coordOnMask.y + vMaskOnFixedImageCoords[1]
	)
);