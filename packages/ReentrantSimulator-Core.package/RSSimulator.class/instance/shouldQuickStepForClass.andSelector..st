private quick-stepping
shouldQuickStepForClass: aClass andSelector: aSymbol
	
	self flag: #todo. "need to always ALLOW BlockClosure for now, since it would otherwise immediately quickstep wrapped blocks"
	aClass == BlockClosure ifTrue: [^ #no].
	(SkippedSelectors includes: aSymbol) ifTrue: [^ #yesNotWrapped].
	(self shouldClassBeQuickStepped: aClass) ifTrue: [^ #yesWrapped].

	^ #no