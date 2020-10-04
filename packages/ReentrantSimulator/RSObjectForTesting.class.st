Class {
	#name : #RSObjectForTesting,
	#superclass : #Object,
	#category : #'ReentrantSimulator-Tests-Support'
}

{ #category : #'as yet unclassified' }
RSObjectForTesting class >> a [

	^ self b + 10
]

{ #category : #'as yet unclassified' }
RSObjectForTesting class >> b [
	
	^ 32
]
