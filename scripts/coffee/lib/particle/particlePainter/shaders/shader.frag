precision highp float;

uniform vec2 win;

varying float vOpacity;

#ifdef TINT

varying vec4 vTint;

#endif

#if defined(FILLWITHIMAGE)

	varying vec4 vFillWithImageCoords;

#elif defined(MASKONIMAGE)

	varying vec4 vMaskOnImageCoords;

	uniform sampler2D pictureAtlasUnit;

#else

	varying vec4 vColor;

#endif

#if defined(MASKWITHIMAGE)

	varying vec4 vMaskWithImageCoords;

	varying float vMaskWithImageChannel;

#endif

#ifdef ZROTATION

	varying float vZRotation;

#endif


#if defined(FILLWITHIMAGE) || defined(MASKWITHIMAGE)

	uniform sampler2D imageAtlasUnit;

#endif

void main() {

	vec2 pointCoord = gl_PointCoord;

	#ifdef ZROTATION

		pointCoord -= 0.5;
		pointCoord /= 1.4142135623;

		pointCoord = vec2(
			(cos(vZRotation) * pointCoord.x) - (sin(vZRotation) * pointCoord.y),
			(sin(vZRotation) * pointCoord.x) + (cos(vZRotation) * pointCoord.y)

		);

		pointCoord += 0.5;

	#endif

	vec2 clipCoord = vec2((gl_FragCoord.x / win.x) - 0.5, (gl_FragCoord.y / win.y) - 0.5) * vec2(2.0);

	#ifdef FILLWITHIMAGE

		vec4 fillColor = texture2D(

			imageAtlasUnit,

			vec2(
				vFillWithImageCoords[2] * pointCoord.x + vFillWithImageCoords[0],
				vFillWithImageCoords[3] * pointCoord.y + vFillWithImageCoords[1]
				)
			);



	#elif defined(MASKONIMAGE)

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

	#else

		vec4 fillColor = vColor;

	#endif

	float opacityMult = 1.0;

	// masking with an image
	#ifdef MASKWITHIMAGE

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
		} else if (vMaskWithImageChannel == 3.0) {
			opacityMult = _mask[2];
		} else if (vMaskWithImageChannel == 3.0) {
			opacityMult = (_mask[1] + _mask[2] + _mask[0]) / 3.0;
		}

	#endif

	#ifdef TINT

		fillColor.rgb = mix(fillColor.rgb, vTint.rgb, vTint[3]);

	#endif

	gl_FragColor = vec4(fillColor.rgb, fillColor[3] * opacityMult * vOpacity);
	// gl_FragColor = vec4(fillColor.rgb, 1.0);

}