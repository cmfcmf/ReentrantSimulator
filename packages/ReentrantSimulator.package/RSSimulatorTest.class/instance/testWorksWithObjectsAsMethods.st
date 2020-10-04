as yet unclassified
testWorksWithObjectsAsMethods
	
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