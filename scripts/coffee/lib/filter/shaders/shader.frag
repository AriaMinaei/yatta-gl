precision highp float;

varying vec2 vTexCoord;

uniform sampler2D layerBeneath;

void main() {

	vec4 tColor = texture2D(layerBeneath, vTexCoord);

	gl_FragColor = 1.0 - tColor;
}