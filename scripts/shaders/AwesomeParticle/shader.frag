precision mediump float;

uniform vec2 win;

#if defined(FILLWITHIMAGE)

	varying vec4 vFillWithImageCoords;

#elif defined(MASKONIMAGE)

	varying vec4 vMaskOnImageCoords;

	uniform sampler2D pictureAtlasSlot;

#else

	varying vec4 vColor;

#endif

#if defined(MASKWITHIMAGE)


	varying vec4 vMaskWithImageCoords;

	varying float vMaskWithImageChannel;

#endif


#if defined(FILLWITHIMAGE) || defined(MASKWITHIMAGE)

	uniform sampler2D imageAtlasSlot;

#endif

void main() {

	vec2 pointCoord = gl_PointCoord;

	vec2 clipCoord = vec2(gl_FragCoord.x / win.x - 1.0, gl_FragCoord.y / win.y - 1.0);

	#ifdef FILLWITHIMAGE

		vec4 fillColor = texture2D(

			imageAtlasSlot,

			vec2(
				vFillWithImageCoords[2] * pointCoord.x + vFillWithImageCoords[0],
				vFillWithImageCoords[3] * pointCoord.y + vFillWithImageCoords[1]
				)
			);

	#elif defined(MASKONIMAGE)



		vec4 fillColor = texture2D(

			pictureAtlasSlot,

			vec2(
				vMaskOnImageCoords[2] * clipCoord.x + vMaskOnImageCoords[0],
				vMaskOnImageCoords[3] * clipCoord.y + vMaskOnImageCoords[1]
				)
			);

	#else

		vec4 fillColor = vColor;

	#endif

	float opacity = 1.0;

	// masking with an image
	#ifdef MASKWITHIMAGE

		// let's sample all the colors first
		vec4 _mask = texture2D(

			imageAtlasSlot,

			vec2(
				vMaskWithImageCoords[2] * pointCoord.x + vMaskWithImageCoords[0],
				vMaskWithImageCoords[3] * pointCoord.y + vMaskWithImageCoords[1]
				)
			);

		// now choose a channel
		if (vMaskWithImageChannel == 0.0) {
			opacity = _mask[0];
		} else if (vMaskWithImageChannel == 1.0) {
			opacity = _mask[1];
		} else if (vMaskWithImageChannel == 2.0) {
			opacity = _mask[2];
		}

	#endif

	gl_FragColor = vec4(fillColor.rgb, fillColor[3] * opacity);
	// gl_FragColor = vec4(fillColor.rgb, 1.0);

}