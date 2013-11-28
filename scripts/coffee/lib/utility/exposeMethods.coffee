module.exports = exposeMethods = (inst) ->

	cls = inst.constructor

	return if cls._methodsExposed

	current = cls

	proto = cls::

	loop

		toExpose = current._methodsToExpose

		if toExpose?

			if Array.isArray(toExpose)

				for set in toExpose

					exposeOn proto, set

			else

				exposeOn proto, toExpose

		break unless current.__super__?

		current = current.__super__.constructor

	cls._methodsExposed = yes

	return

exposeOn = (proto, toExpose) ->

	for name, func of toExpose

		proto[name] = func

	return