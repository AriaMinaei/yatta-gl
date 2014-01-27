pointCoord -= 0.5;
pointCoord /= 1.4142135623;

pointCoord = vec2(
	(cos(vZRotation) * pointCoord.x) - (sin(vZRotation) * pointCoord.y),
	(sin(vZRotation) * pointCoord.x) + (cos(vZRotation) * pointCoord.y)

);

pointCoord += 0.5;