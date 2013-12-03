module.exports.vert = """
//attribute vec3 vx;

//uniform vec2 uDims;

//uniform mat4 uTrans;

//uniform mat4 uPers;

//varying vec2 vTextureCoord;

void main(void) {
	//gl_Position = uPers * uTrans * (vec4(vx, 1) * vec4(uDims, 1, 1)); // * vec4(0.5, 1, 1, 1);

	//vTextureCoord = (vx.xy + vec2(1)) / vec2(2);

	gl_Position = vec4(0, 0, 0, 1);

	gl_PointSize = 200.0;
}
"""

module.exports.frag = """
precision mediump float;

uniform sampler2D maskTextureSlot;

uniform int maskTextureFillChannel;

uniform float zRotation;

uniform vec4 fillColor;

// 0: color, 1: texture, 2: fixedPositionTexture
uniform int fillType;

void main() {

	float x = gl_PointCoord.x - 0.5;
	float y = gl_PointCoord.y - 0.5;

	float cosT = cos(zRotation);
	float sinT = sin(zRotation);

	vec2 textureCoord = vec2(x * cosT - y * sinT, x * sinT + y * cosT) + 0.5;

	float mask;

	if (maskTextureFillChannel == 0) {
		mask = texture2D(maskTextureSlot, textureCoord).r;
	} else if (maskTextureFillChannel == 1) {
		mask = texture2D(maskTextureSlot, textureCoord).g;
	} else if (maskTextureFillChannel == 2) {
		mask = texture2D(maskTextureSlot, textureCoord).b;
	} else {
		mask = 1.0;
	}

	vec4 color;

	if (fillType == 0) {
		color = fillColor;
	}

	gl_FragColor = color * vec4(mask);

}
"""