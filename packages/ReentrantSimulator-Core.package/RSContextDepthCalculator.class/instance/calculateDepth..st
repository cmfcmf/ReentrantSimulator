public
calculateDepth: aContext
	
	"Calculate the depth of aContext below this calculator's root context. If no root context has been set, set aContext as root context"
	
	self flag: #todo. "Revisit using a cached approach as shown at the bottom."

	rootContext ifNil: [rootContext := aContext].
	^ (aContext depthBelow: rootContext) + fixedOffset.
	
	"| this depth |
	""based on Context >> #depthBelow:""
	root ifNil: [root := aContext].
	this := aContext.
	depth := fixedOffset.
	[this == root or: [this == nil]] whileFalse: [
		cache at: this ifPresent: [:d | ^ cache at: aContext put: d + depth].
		this := this sender.
		depth := depth + 1].
	^ cache at: aContext put: depth"