public
simulateIfNeeded: aBlock additionalDepth: aNumber
	
	aNumber == -1 ifTrue: [^ aBlock value].
	RSRestartTracingNotification signal
		ifNil: [^ aBlock value]
		ifNotNil: [:simulator | ^ simulator simulateWithExistingRecorder: aBlock additionalDepth: aNumber]