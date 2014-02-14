vec4 fillColor = texture2D(

	pictureAtlasUnit,

	vec2(
		vMaskOnFixedImageCoords[2] * coordOnMask.x + vMaskOnFixedImageCoords[0],
		vMaskOnFixedImageCoords[3] * coordOnMask.y + vMaskOnFixedImageCoords[1]
	)
);