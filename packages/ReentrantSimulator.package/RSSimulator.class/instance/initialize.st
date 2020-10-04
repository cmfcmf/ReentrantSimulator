initialize-release
initialize
	

	super initialize.
	depthCalculator := RSContextDepthCalculator new.
	quickSteppedCategories := OrderedCollection new