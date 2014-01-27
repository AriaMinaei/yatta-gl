// let's sample all the colors first
vec4 _mask = texture2D(

	imageAtlasUnit,

	vec2(
		vMaskWithImageCoords[2] * pointCoord.x + vMaskWithImageCoords[0],
		vMaskWithImageCoords[3] * pointCoord.y + vMaskWithImageCoords[1]
		)
	);

// now choose a channel
if (vMaskWithImageChannel == 0.0) {
	opacityMult = _mask[0];
} else if (vMaskWithImageChannel == 1.0) {
	opacityMult = _mask[1];
} else if (vMaskWithImageChannel == 2.0) {
	opacityMult = _mask[2];
}