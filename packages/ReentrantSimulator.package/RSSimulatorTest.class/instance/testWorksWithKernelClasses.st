as yet unclassified
testWorksWithKernelClasses
	
	| trace |
	trace := String streamContents: [:stream | RSSimulator trace: [3 factorial] on: stream].
	self assert: '
RSSimulatorTest>>#testWorksWithKernelClasses testWorksWithKernelClasses
 3 factorial
  2 factorial
   1 factorial
    0 factorial ^1
   1 factorial ^1
  2 factorial ^2
 3 factorial ^6
RSSimulatorTest>>#testWorksWithKernelClasses testWorksWithKernelClasses' equals: trace