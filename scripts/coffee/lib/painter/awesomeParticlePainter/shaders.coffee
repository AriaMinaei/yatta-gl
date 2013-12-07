module.exports.vert = """

attribute vec3 pos;

attribute lowp float size;

attribute lowp vec4 color;

varying vec4 vColor;

void main(void) {

	vColor = color;

	gl_Position = vec4(pos, 1);

	gl_PointSize = float(size);
}
"""

module.exports.frag = """
precision mediump float;

varying vec4 vColor;

void main() {
	gl_FragColor = vColor;
}
"""