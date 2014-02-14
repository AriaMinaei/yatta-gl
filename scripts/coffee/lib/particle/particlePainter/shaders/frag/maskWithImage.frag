vec2 maskWithImagePos;

maskWithImagePos = vec2(
	vMaskWithImageCoords[2] * pointCoord.x + vMaskWithImageCoords[0],
	vMaskWithImageCoords[3] * pointCoord.y + vMaskWithImageCoords[1]
	);

float maskWithImageOpacity;

if (vMaskWithImageChannel == 0.0) {

	maskWithImageOpacity = texture2D(imageAtlasUnit, maskWithImagePos)[0];

} else if (vMaskWithImageChannel == 1.0) {

	maskWithImageOpacity = texture2D(imageAtlasUnit, maskWithImagePos)[1];

} else if (vMaskWithImageChannel == 2.0) {

	maskWithImageOpacity = texture2D(imageAtlasUnit, maskWithImagePos)[2];

}

#ifdef MOTIONBLUR

vec2 _velocity = clamp(vVelocity, vec2(-0.22, -0.22), vec2(0.22, 0.22));

if (pointCoord.x < 0.1 || pointCoord.x > 0.9 || pointCoord.y < 0.1 || pointCoord.y > 0.9) {
	discard;
}

maskWithImagePos = vec2(
	// X
	vMaskWithImageCoords[2] * pointCoord.x + vMaskWithImageCoords[0] + (0.05 * _velocity.x)

	,
	// Y
	vMaskWithImageCoords[3] * pointCoord.y + vMaskWithImageCoords[1] + (0.05 * -_velocity.y)

	);
maskWithImageOpacity += texture2D(imageAtlasUnit, maskWithImagePos)[0];

maskWithImagePos = vec2(
	// X
	vMaskWithImageCoords[2] * pointCoord.x + vMaskWithImageCoords[0] + (0.1 * _velocity.x)

	,
	// Y
	vMaskWithImageCoords[3] * pointCoord.y + vMaskWithImageCoords[1] + (0.1 * -_velocity.y)

	);
maskWithImageOpacity += texture2D(imageAtlasUnit, maskWithImagePos)[0];

maskWithImagePos = vec2(
	// X
	vMaskWithImageCoords[2] * pointCoord.x + vMaskWithImageCoords[0] + (0.15 * _velocity.x)

	,
	// Y
	vMaskWithImageCoords[3] * pointCoord.y + vMaskWithImageCoords[1] + (0.15 * -_velocity.y)

	);
maskWithImageOpacity += texture2D(imageAtlasUnit, maskWithImagePos)[0];

maskWithImagePos = vec2(
	// X
	vMaskWithImageCoords[2] * pointCoord.x + vMaskWithImageCoords[0] + (0.2 * _velocity.x)

	,
	// Y
	vMaskWithImageCoords[3] * pointCoord.y + vMaskWithImageCoords[1] + (0.2 * -_velocity.y)

	);
maskWithImageOpacity += texture2D(imageAtlasUnit, maskWithImagePos)[0];

maskWithImagePos = vec2(
	// X
	vMaskWithImageCoords[2] * pointCoord.x + vMaskWithImageCoords[0] + (0.25 * _velocity.x)

	,
	// Y
	vMaskWithImageCoords[3] * pointCoord.y + vMaskWithImageCoords[1] + (0.25 * -_velocity.y)

	);
maskWithImageOpacity += texture2D(imageAtlasUnit, maskWithImagePos)[0];

maskWithImagePos = vec2(
	// X
	vMaskWithImageCoords[2] * pointCoord.x + vMaskWithImageCoords[0] + (0.3 * _velocity.x)

	,
	// Y
	vMaskWithImageCoords[3] * pointCoord.y + vMaskWithImageCoords[1] + (0.3 * -_velocity.y)

	);

maskWithImageOpacity += texture2D(imageAtlasUnit, maskWithImagePos)[0];

maskWithImageOpacity /= 7.0;

#endif

opacityMult *= maskWithImageOpacity;