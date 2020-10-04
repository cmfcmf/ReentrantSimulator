public
trace: aBlock
	<exampleNamed: 'Morph new' self: 'RSSimulator' with: '[Morph new]'>
	Transcript clear; openIfNone.
	^ self trace: aBlock on: Transcript