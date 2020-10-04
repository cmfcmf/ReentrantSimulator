public
trace: aBlock on: aStream
	
	"based on Context >> #trace:on"
	| prev |
	prev := aBlock.
	^ self simulate: aBlock withRecorder: [:event :data |
		event caseOf: {
			[#step] -> [ | current depth |
				current := data first.
				depth := data second.
				current ~= prev ifTrue: [ 
					prev sender ifNil: [
						"the previous context no longer has a sender -> it has just returned. The return value is now on top of the stack (current top)"
						aStream space; nextPut: $^.
						Context carefullyPrint: current top on: aStream].
					aStream cr.
					depth timesRepeat: [aStream space].
					Context carefullyPrint: current receiver on: aStream.
					aStream space; nextPutAll: current selector; flush. 
					prev := current]]
		}]