public
simulateIfNeeded: aBlock additionalDepth: aNumber
	
	aNumber == -1 ifTrue: [^ aBlock value].
	RSRestartTracingNotification signal
		ifNil: [^ aBlock value]
		ifNotNil: [:simulator | ^ [simulator simulateWithExistingRecorder: aBlock additionalDepth: aNumber] 
			"make sure that we do not accidentally bubble up a restart tracing notification"
			on: RSRestartTracingNotification 
			do: [:e | e resume]]