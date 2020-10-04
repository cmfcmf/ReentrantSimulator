system primitives
doesNotUnderstand: aMessage
	
	| arguments selector |
	
	proxiedObject ifNil: [Error signal: 'empty proxy'].
	selector := aMessage selector.
	arguments := aMessage arguments.
	^ RSSimulator simulateIfNeeded: [
		"we cannot use aMessage >> #sendTo: here, since that causes an infinite loop."
		proxiedObject perform: selector withArguments: arguments] additionalDepth: 0