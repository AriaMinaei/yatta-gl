module.exports.vert = """
attribute vec3 vx;

uniform vec2 uDims;

uniform mat4 uTrans;

uniform mat4 uPers;

varying vec2 vTextureCoord;

void main(void) {
	gl_Position = uPers * uTrans * (vec4(vx, 1) * vec4(uDims, 1, 1)); // * vec4(0.5, 1, 1, 1);

	vTextureCoord = (vx.xy + vec2(1)) / vec2(2);
}
"""

module.exports.frag = """
precision mediump float;

varying vec2 vTextureCoord;

uniform sampler2D textureSlot;

uniform int textureFillChannel;

void main() {

	if (textureFillChannel == 0) {
		gl_FragColor = vec4(texture2D(textureSlot, vTextureCoord).r);
	} else if (textureFillChannel == 1) {
		gl_FragColor = vec4(texture2D(textureSlot, vTextureCoord).g);
	} else if (textureFillChannel == 2) {
		gl_FragColor = vec4(texture2D(textureSlot, vTextureCoord).b);
	} else {
		gl_FragColor = texture2D(textureSlot, vTextureCoord);
	}

}
"""