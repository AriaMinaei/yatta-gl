precision highp float;

varying vec2 vTexCoord;

uniform sampler2D image;

void main() {
	gl_FragColor = texture2D(image, vTexCoord);
}