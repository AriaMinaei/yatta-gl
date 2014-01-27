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

#ifdef MOTIONBLUR

	varying vec2 vVelocity;

#endif

void main() {

	vec2 pointCoord = gl_PointCoord;

	#ifdef ZROTATION

		// include ./frag/zRotation.frag

	#endif

	vec2 clipCoord = vec2((gl_FragCoord.x / win.x) - 0.5, (gl_FragCoord.y / win.y) - 0.5) * vec2(2.0);

	#ifdef FILLWITHIMAGE

		// include ./frag/fillWithImage.frag

	#elif defined(MASKONIMAGE)

		// include ./frag/maskOnImage.frag

	#else

		vec4 fillColor = vColor;

	#endif

	float opacityMult = 1.0;

	// masking with an image
	#ifdef MASKWITHIMAGE

		//include ./frag/maskWithImage.frag

	#endif

	#ifdef TINT

		fillColor.rgb = mix(fillColor.rgb, vTint.rgb, vTint[3]);

	#endif

	gl_FragColor = vec4(fillColor.rgb, fillColor[3] * opacityMult * vOpacity);
	// gl_FragColor = vec4(fillColor.rgb, 1.0);

}