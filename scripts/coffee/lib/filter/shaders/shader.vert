attribute vec2 vx;

varying vec2 vTexCoord;

void main() {
	gl_Position = vec4(vx, 0.0, 1.0);

	vTexCoord = vec2(vx / 2.0 + 0.5);
}