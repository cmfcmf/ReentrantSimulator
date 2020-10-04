instance creation
exists

	self allInstancesDo: [:proxy | ^ true].
	^ false