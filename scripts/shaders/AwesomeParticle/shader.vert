attribute vec3 pos;

attribute lowp float size;

#ifdef FILLWITHIMAGE

	attribute vec4 fillWithImageCoords;

	varying vec4 vFillWithImageCoords;

#else

	attribute lowp vec4 color;

	varying vec4 vColor;

#endif

void main(void) {

	#ifdef FILLWITHIMAGE

		vFillWithImageCoords = fillWithImageCoords;

	#else

		vColor = color;

	#endif

	gl_Position = vec4(pos, 1);

	gl_PointSize = float(size);
}