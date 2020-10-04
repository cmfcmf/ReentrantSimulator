private
simulateWithExistingRecorder: aBlock additionalDepth: aNumber
	
	| instance |
	instance := self class new.
	instance depthCalculator fixedOffset: (depthCalculator calculateDepth: currentContext) + aNumber.
	instance quickSteppedCategories: quickSteppedCategories.
	^ instance simulate: aBlock withRecorder: recorder