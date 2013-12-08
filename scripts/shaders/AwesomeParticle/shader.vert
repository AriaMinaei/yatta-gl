attribute vec3 pos;

attribute lowp float size;


#ifdef FILLWITHIMAGE

	attribute vec4 fillWithImageCoords;

	varying vec4 vFillWithImageCoords;

#else

	attribute lowp vec4 color;

	varying vec4 vColor;

#endif

#ifdef MASKWITHIMAGE

	attribute vec4 maskWithImageCoords;

	varying vec4 vMaskWithImageCoords;

	attribute float maskWithImageChannel;

	varying float vMaskWithImageChannel;

#endif

void main(void) {

	#ifdef FILLWITHIMAGE

		vFillWithImageCoords = fillWithImageCoords;

	#else

		vColor = color;

	#endif

	#ifdef MASKWITHIMAGE

		vMaskWithImageCoords = maskWithImageCoords;

		vMaskWithImageChannel = maskWithImageChannel;

	#endif

	gl_Position = vec4(pos, 1);

	gl_PointSize = float(size);
}