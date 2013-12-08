precision mediump float;

#ifdef FILLWITHIMAGE

	uniform sampler2D atlasSlot;

	varying vec4 vFillWithImageCoords;

#else

	varying vec4 vColor;

#endif

void main() {

	#ifdef FILLWITHIMAGE

		vec4 fillColor = texture2D(

			atlasSlot,

			vec2(
				vFillWithImageCoords[2] * gl_PointCoord.x + vFillWithImageCoords[0],
				vFillWithImageCoords[3] * gl_PointCoord.y + vFillWithImageCoords[1]
				)
			);

	#else

		vec4 fillColor = vColor;

	#endif

	gl_FragColor = fillColor;
}