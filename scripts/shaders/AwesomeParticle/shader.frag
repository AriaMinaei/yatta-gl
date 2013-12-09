precision mediump float;

uniform vec2 window;

#ifdef FILLWITHIMAGE

	varying vec4 vFillWithImageCoords;

#else

	varying vec4 vColor;

#endif

#ifdef MASKWITHIMAGE


	varying vec4 vMaskWithImageCoords;

	varying float vMaskWithImageChannel;

#endif


#if defined(FILLWITHIMAGE) || defined(MASKWITHIMAGE)

	uniform sampler2D atlasSlot;

#endif

void main() {

	vec2 pointCoord = gl_PointCoord;

	#ifdef FILLWITHIMAGE

		vec4 fillColor = texture2D(

			atlasSlot,

			vec2(
				vFillWithImageCoords[2] * pointCoord.x + vFillWithImageCoords[0],
				vFillWithImageCoords[3] * pointCoord.y + vFillWithImageCoords[1]
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

			atlasSlot,

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

	gl_FragColor = vec4(fillColor.xyz, fillColor[3] * opacity);
	// gl_FragColor = vec4(fillColor.rgb, 1.0);

}