Class {
	#name : #RSSimulatorTest,
	#superclass : #TestCase,
	#category : #'ReentrantSimulator-Tests'
}

{ #category : #'as yet unclassified' }
RSSimulatorTest >> testWorks [
	
	| trace |
	trace := String streamContents: [:stream | RSSimulator trace: [RSObjectForTesting a] on: stream].
	self assert: '
RSSimulatorTest>>#testWorks testWorks
 RSObjectForTesting a
  RSObjectForTesting b ^32
 RSObjectForTesting a ^42
RSSimulatorTest>>#testWorks testWorks' equals: trace
]

{ #category : #'as yet unclassified' }
RSSimulatorTest >> testWorksWithKernelClasses [
	
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
]

{ #category : #'as yet unclassified' }
RSSimulatorTest >> testWorksWithObjectsAsMethods [
	
	| mw trace wrapper |
	mw := Smalltalk at: #MwMethodWrapper.
	wrapper := mw on: #b inClass: RSObjectForTesting class.
	wrapper install.
	[
		trace := String streamContents: [:stream | RSSimulator trace: [RSObjectForTesting a] on: stream].
		self assert: '
RSSimulatorTest>>#testWorksWithObjectsAsMethods testWorksWithObjectsAsMethods
 RSObjectForTesting a
  a MwMethodWrapper valueWithReceiver:arguments:
   [closure] in MwMethodWrapper>>valueWithReceiver:arguments: ensure:
    a MwMethodWrapper valueWithReceiver:arguments:
     (RSObjectForTesting class>>#b "a CompiledMethod(778910)") valueWithReceiver:arguments:
      RSObjectForTesting b ^32
     (RSObjectForTesting class>>#b "a CompiledMethod(778910)") valueWithReceiver:arguments: ^32
    a MwMethodWrapper valueWithReceiver:arguments: ^32
   [closure] in MwMethodWrapper>>valueWithReceiver:arguments: ensure:
    a MwMethodWrapper valueWithReceiver:arguments: ^a MwMethodWrapper
   [closure] in MwMethodWrapper>>valueWithReceiver:arguments: ensure: ^32
  a MwMethodWrapper valueWithReceiver:arguments: ^32
 RSObjectForTesting a ^42
RSSimulatorTest>>#testWorksWithObjectsAsMethods testWorksWithObjectsAsMethods' equals: trace] ensure: [wrapper uninstall]
]
