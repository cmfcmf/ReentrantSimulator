Extension { #name : #Context }

{ #category : #'*ReentrantSimulator-Core' }
Context >> markForQuickStep [
	
	QuickStep := self
]

{ #category : #'*ReentrantSimulator-Core' }
Context >> resetMarkForQuickStep [
	
	QuickStep := nil
]

{ #category : #'*ReentrantSimulator-Core' }
Context >> shouldQuickStep [

	^ QuickStep == self
]
