vec2 pos;

pos = vec2(
	vMaskWithImageCoords[2] * pointCoord.x + vMaskWithImageCoords[0],
	vMaskWithImageCoords[3] * pointCoord.y + vMaskWithImageCoords[1]
	);

if (vMaskWithImageChannel == 0.0) {

	opacityMult = texture2D(imageAtlasUnit, pos)[0];

} else if (vMaskWithImageChannel == 1.0) {

	opacityMult = texture2D(imageAtlasUnit, pos)[1];

} else if (vMaskWithImageChannel == 2.0) {

	opacityMult = texture2D(imageAtlasUnit, pos)[2];

}

#ifdef MOTIONBLUR

vec2 _velocity = clamp(vVelocity, vec2(-0.22, -0.22), vec2(0.22, 0.22));

if (pointCoord.x < 0.1 || pointCoord.x > 0.9 || pointCoord.y < 0.1 || pointCoord.y > 0.9) {
	discard;
}

pos = vec2(
	// X
	vMaskWithImageCoords[2] * pointCoord.x + vMaskWithImageCoords[0] + (0.05 * _velocity.x)

	,
	// Y
	vMaskWithImageCoords[3] * pointCoord.y + vMaskWithImageCoords[1] + (0.05 * -_velocity.y)

	);
opacityMult += texture2D(imageAtlasUnit, pos)[0];

pos = vec2(
	// X
	vMaskWithImageCoords[2] * pointCoord.x + vMaskWithImageCoords[0] + (0.1 * _velocity.x)

	,
	// Y
	vMaskWithImageCoords[3] * pointCoord.y + vMaskWithImageCoords[1] + (0.1 * -_velocity.y)

	);
opacityMult += texture2D(imageAtlasUnit, pos)[0];

pos = vec2(
	// X
	vMaskWithImageCoords[2] * pointCoord.x + vMaskWithImageCoords[0] + (0.15 * _velocity.x)

	,
	// Y
	vMaskWithImageCoords[3] * pointCoord.y + vMaskWithImageCoords[1] + (0.15 * -_velocity.y)

	);
opacityMult += texture2D(imageAtlasUnit, pos)[0];

pos = vec2(
	// X
	vMaskWithImageCoords[2] * pointCoord.x + vMaskWithImageCoords[0] + (0.2 * _velocity.x)

	,
	// Y
	vMaskWithImageCoords[3] * pointCoord.y + vMaskWithImageCoords[1] + (0.2 * -_velocity.y)

	);
opacityMult += texture2D(imageAtlasUnit, pos)[0];

pos = vec2(
	// X
	vMaskWithImageCoords[2] * pointCoord.x + vMaskWithImageCoords[0] + (0.25 * _velocity.x)

	,
	// Y
	vMaskWithImageCoords[3] * pointCoord.y + vMaskWithImageCoords[1] + (0.25 * -_velocity.y)

	);
opacityMult += texture2D(imageAtlasUnit, pos)[0];

pos = vec2(
	// X
	vMaskWithImageCoords[2] * pointCoord.x + vMaskWithImageCoords[0] + (0.3 * _velocity.x)

	,
	// Y
	vMaskWithImageCoords[3] * pointCoord.y + vMaskWithImageCoords[1] + (0.3 * -_velocity.y)

	);

opacityMult += texture2D(imageAtlasUnit, pos)[0];

opacityMult /= 7.0;

#endif