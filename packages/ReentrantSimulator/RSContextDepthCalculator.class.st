Class {
	#name : #RSContextDepthCalculator,
	#superclass : #Object,
	#instVars : [
		'cache',
		'rootContext',
		'fixedOffset'
	],
	#category : #'ReentrantSimulator-Core'
}

{ #category : #'instance creation' }
RSContextDepthCalculator class >> forRootContext: aContext [
	
	^ self new
		rootContext: aContext;
		yourself
]

{ #category : #public }
RSContextDepthCalculator >> calculateDepth: aContext [
	
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
]

{ #category : #accessing }
RSContextDepthCalculator >> fixedOffset [

	^ fixedOffset
]

{ #category : #accessing }
RSContextDepthCalculator >> fixedOffset: aNumber [

	fixedOffset := aNumber
]

{ #category : #'initialize-release' }
RSContextDepthCalculator >> initialize [
	

	super initialize.
	rootContext := nil.
	fixedOffset := 0.
	cache := WeakIdentityKeyDictionary new
]

{ #category : #accessing }
RSContextDepthCalculator >> rootContext: aContext [
	
	rootContext := aContext
]
