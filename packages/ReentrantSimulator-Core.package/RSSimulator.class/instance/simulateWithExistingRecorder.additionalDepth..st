private
simulateWithExistingRecorder: aBlock additionalDepth: aNumber
	
	<primitive: 19> "simulation guard"
	| instance |
	instance := self class new.
	instance depthCalculator fixedOffset: (depthCalculator calculateDepth: currentContext) + aNumber.
	instance config: self config.
	^ instance simulate: aBlock withRecorder: recorder