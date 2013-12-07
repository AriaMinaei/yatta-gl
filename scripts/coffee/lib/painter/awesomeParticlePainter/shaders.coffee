module.exports.vert = """

attribute vec3 pos;

attribute float size;

void main(void) {

	gl_Position = vec4(pos, 1);

	gl_PointSize = size;
}
"""

module.exports.frag = """
precision mediump float;

uniform vec3 color;

void main() {
	gl_FragColor = vec4(color, 1.0);
}
"""