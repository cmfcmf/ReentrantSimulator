public
simulate: aBlock withRecorder: aRecorder
	
	| simulationContext rootContext |
	aBlock hasMethodReturn ifTrue: [self error: 'simulation of blocks with ^ can run loose'].
	recorder := aRecorder.
	simulationContext := thisContext.
	currentContext := rootContext := aBlock asContext.
	currentContext pushArgs: Array new from: simulationContext.
	[currentContext notNil and: [currentContext ~~ simulationContext]] whileTrue: [
		"currentContext ~= rootContext" true ifTrue: [ | depth |
			"we need to calculate the depth here, since currentContext sender is nilled once it returns -> therefore loosing any chance of calculating the depth information"
			depth := depthCalculator calculateDepth: currentContext.
			aRecorder value: #step value: {currentContext . depth}].
		self simulateNextInstruction].
	^ currentContext ifNil: [nil] ifNotNil: [simulationContext pop]