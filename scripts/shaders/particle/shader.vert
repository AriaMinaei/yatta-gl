precision highp float;

attribute vec3 pos;

attribute float size;

attribute float opacity;

varying float vOpacity;

// Dimensions of the canvas (perceived dimensions), divided in 2.
// We'll use this to convert clip-space coords to window-space coords
uniform vec2 win;

// We can either fill the particle with an image...
#if defined(FILLWITHIMAGE)

	attribute vec4 fillWithImageCoords;

	varying vec4 vFillWithImageCoords;

// or mask it on an image
#elif defined(MASKONIMAGE)

	attribute vec4 maskOnImageCoords;

	varying vec4 vMaskOnImageCoords;

#else

	// A regular color vector
	attribute vec4 color;

	// we'll pas this color to the fragment shader
	varying vec4 vColor;

#endif

#ifdef TINT

attribute vec4 tint;

varying vec4 vTint;

#endif

// We can mask the final color with another image
#ifdef MASKWITHIMAGE

	// the image's coordinates in the texture atlas
	attribute vec4 maskWithImageCoords;

	// we'll have to pass that to the fragment shader
	varying vec4 vMaskWithImageCoords;

	// we'll use one of the channels from that image to use
	// as an opacity mask
	attribute float maskWithImageChannel;

	// and we'll pass it to the fragment shader
	varying float vMaskWithImageChannel;

#endif

void main(void) {

	#ifdef TINT

		vTint = tint;

	#endif

	vOpacity = opacity;

	#if defined(FILLWITHIMAGE)

		vFillWithImageCoords = fillWithImageCoords;

	#elif defined(MASKONIMAGE)

		vMaskOnImageCoords = maskOnImageCoords;

	#else

		vColor = color;

	#endif

	#if defined(MASKWITHIMAGE)

		vMaskWithImageCoords = maskWithImageCoords;

		vMaskWithImageChannel = maskWithImageChannel;

	#endif

	vec3 finalPosition = vec3(pos.xy / (win.xy / 2.0), pos.z);

	gl_Position = vec4(finalPosition, 1);

	gl_PointSize = float(size);
}