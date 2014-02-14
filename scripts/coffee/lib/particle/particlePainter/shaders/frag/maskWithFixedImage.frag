vec2 maskWithFixedImagePos;

maskWithFixedImagePos = vec2(
	vMaskWithFixedImageCoords[2] * coordOnMask.x + vMaskWithFixedImageCoords[0],
	vMaskWithFixedImageCoords[3] * coordOnMask.y + vMaskWithFixedImageCoords[1]
	);

if (vMaskWithFixedImageChannel == 0.0) {

	opacityMult *= texture2D(imageAtlasUnit, maskWithFixedImagePos)[0];

} else if (vMaskWithFixedImageChannel == 1.0) {

	opacityMult *= texture2D(imageAtlasUnit, maskWithFixedImagePos)[1];

} else if (vMaskWithFixedImageChannel == 2.0) {

	opacityMult *= texture2D(imageAtlasUnit, maskWithFixedImagePos)[2];

}