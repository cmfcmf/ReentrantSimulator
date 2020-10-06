testing
shouldQuickStepForClass: aClass andSelector: aSymbol
	
	self flag: #todo. "need to always ALLOW BlockClosure for now, since it would otherwise immediately quickstep wrapped blocks"
	aClass == BlockClosure ifTrue: [^ #no].
	
	quickClassSelectors at: aClass ifPresent: [:symbols | symbols at: aSymbol ifPresent: [:type | ^ type]].
	quickSelectors at: aSymbol ifPresent: [:type | ^ type].
	
	^ self shouldClassBeQuickStepped: aClass