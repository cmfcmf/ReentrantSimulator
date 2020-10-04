as yet unclassified
testWorks
	
	| trace |
	trace := String streamContents: [:stream | RSSimulator trace: [RSObjectForTesting a] on: stream].
	self assert: '
RSSimulatorTest>>#testWorks testWorks
 RSObjectForTesting a
  RSObjectForTesting b ^32
 RSObjectForTesting a ^42
RSSimulatorTest>>#testWorks testWorks' equals: trace