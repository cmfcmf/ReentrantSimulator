Class {
	#name : #RSSimulator,
	#superclass : #InstructionClient,
	#instVars : [
		'currentContext',
		'recorder',
		'depthCalculator',
		'quickSteppedCategories'
	],
	#classVars : [
		'SkippedSelectors'
	],
	#category : #'ReentrantSimulator-Core'
}

{ #category : #'class initialization' }
RSSimulator class >> initialize [
	
	"RSSimulator initialize"

	super initialize.
	SkippedSelectors := Object methodsInCategory: #'*Babylonian-Core'
]

{ #category : #public }
RSSimulator class >> simulate: aBlock withRecorder: aRecorder [

	^ self new simulate: aBlock withRecorder: aRecorder
]

{ #category : #public }
RSSimulator class >> simulateIfNeeded: aBlock additionalDepth: aNumber [
	
	aNumber == -1 ifTrue: [^ aBlock value].
	RSRestartTracingNotification signal
		ifNil: [^ aBlock value]
		ifNotNil: [:simulator | ^ simulator simulateWithExistingRecorder: aBlock additionalDepth: aNumber]
]

{ #category : #public }
RSSimulator class >> trace: aBlock [
	<exampleNamed: 'Morph new' self: 'RSSimulator' with: '[Morph new]'>
	Transcript clear; openIfNone.
	^ self trace: aBlock on: Transcript
]

{ #category : #public }
RSSimulator class >> trace: aBlock on: aStream [
	
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
]

{ #category : #'passthrough instruction decoding' }
RSSimulator >> blockReturnConstant: value [
	
	^ currentContext blockReturnConstant: value
]

{ #category : #'passthrough instruction decoding' }
RSSimulator >> blockReturnTop [

	^ currentContext blockReturnTop
]

{ #category : #'passthrough instruction decoding' }
RSSimulator >> callPrimitive: pimIndex [
	"SqueakV3PlusClosures:	239 11101111	iiiiiiii   jjjjjjjj  Call Primitive #iiiiiiii + (jjjjjjjj * 256)
	 NewsqueakV4:				249 11111001	iiiiiiii   jjjjjjjj  Call Primitive #iiiiiiii + (jjjjjjjj * 256)
	 SistaV1:					248 11111000 iiiiiiii mjjjjjjj  Call Primitive #iiiiiiii + (jjjjjjj * 256)
									m=1 means inlined primitive, no hard return after execution."
	^ currentContext callPrimitive: pimIndex
]

{ #category : #accessing }
RSSimulator >> depthCalculator [

	^ depthCalculator 
]

{ #category : #'passthrough instruction decoding' }
RSSimulator >> directedSuperSend: selector numArgs: numArgs [
	"Send Message Above Specific Class With Selector, selector, bytecode.
	 Start the lookup above the class that is the value of the association on
	 top of stack. The arguments  of the message are found in the top numArgs
	 stack locations beneath the association, and the receiver just below them."
	^ currentContext directedSuperSend: selector numArgs: numArgs
]

{ #category : #'passthrough instruction decoding' }
RSSimulator >> doDup [
	"Duplicate Top Of Stack bytecode."
	^ currentContext doDup
]

{ #category : #'passthrough instruction decoding' }
RSSimulator >> doPop [
	"Remove Top Of Stack bytecode."
	^ currentContext doPop
]

{ #category : #'overwritten instruction decoding' }
RSSimulator >> doPrimitive: primitiveIndex method: meth receiver: receiver args: arguments [
	
	"Simulate a primitive method whose index is primitiveIndex.  The simulated receiver and
	 arguments are given as arguments to this message. If successful, push result and return
	 resuming context, else ^ {errCode, PrimitiveFailToken}. Any primitive which provokes
	 execution needs to be intercepted and simulated to avoid execution running away."

	primitiveIndex = 84 ifTrue: "afr 9/11/1998 19:50 & eem 8/18/2009 17:04" "Object>>perform:withArguments:"
		[^self send: arguments first to: receiver with: (arguments at: 2) lookupIn: (currentContext objectClass: receiver)].
	
	^ currentContext doPrimitive: primitiveIndex method: meth receiver: receiver args: arguments
]

{ #category : #'private quick-stepping' }
RSSimulator >> doQuick: type selector: selector rcvr: rcvr arguments: arguments lookupClass: lookupClass [
	
	type caseOf: {
		[#yesNotWrapped] ->[ | result |
			"no need to do any shenanigans here, since the Tracer is already modified to restart tracing when running user code"
			result := self quickSend: selector to: rcvr with: arguments lookupIn: lookupClass.
			selector caseOf: {
				[#bpAssertAfter:that:forAssertion:given:inContext:] -> [self recordAssertionHit: arguments third].
				[#bpTrace:forProbe:inContext:] -> [self recordProbeHit: arguments second].
				[#bpTrace:through:forProbe:inContext:] -> [self recordProbeHit: arguments third].
				[#bpTraceAssignmentOf:before:forProbe:inContext:] -> [self recordProbeHit: arguments third].
			} otherwise: [].
			^ result].
		[#yesWrapped] -> [ | args |
			args := arguments collect: [:arg | self wrapArgument: arg].
			^ self quickSend: selector to: rcvr with: args lookupIn: lookupClass].
	}
]

{ #category : #'initialize-release' }
RSSimulator >> initialize [
	

	super initialize.
	depthCalculator := RSContextDepthCalculator new.
	quickSteppedCategories := OrderedCollection new
]

{ #category : #'passthrough instruction decoding' }
RSSimulator >> jump: offset [
	"Unconditional Jump bytecode."
	^ currentContext jump: offset
]

{ #category : #'passthrough instruction decoding' }
RSSimulator >> jump: offset if: condition [ 
	"Conditional Jump bytecode."
	^ currentContext jump: offset if: condition
]

{ #category : #'passthrough instruction decoding' }
RSSimulator >> methodReturnConstant: value [ 

	^ currentContext methodReturnConstant: value
]

{ #category : #'passthrough instruction decoding' }
RSSimulator >> methodReturnReceiver [

	^ currentContext methodReturnReceiver
]

{ #category : #'passthrough instruction decoding' }
RSSimulator >> methodReturnTop [

	^ currentContext methodReturnTop
]

{ #category : #'passthrough instruction decoding' }
RSSimulator >> popIntoLiteralVariable: anAssociation [ 
	"Remove Top Of Stack And Store Into Literal Variable bytecode."
	^ currentContext popIntoLiteralVariable: anAssociation
]

{ #category : #'passthrough instruction decoding' }
RSSimulator >> popIntoReceiverVariable: offset [
	"Remove Top Of Stack And Store Into Instance Variable bytecode."
	^ currentContext popIntoReceiverVariable: offset
]

{ #category : #'passthrough instruction decoding' }
RSSimulator >> popIntoRemoteTemp: remoteTempIndex inVectorAt: tempVectorIndex [
	"Remove Top Of Stack And Store Into Offset of Temp Vector bytecode."
	^ currentContext popIntoRemoteTemp: remoteTempIndex inVectorAt: tempVectorIndex
]

{ #category : #'passthrough instruction decoding' }
RSSimulator >> popIntoTemporaryVariable: offset [ 
	"Remove Top Of Stack And Store Into Temporary Variable bytecode."
	^ currentContext popIntoTemporaryVariable: offset
]

{ #category : #'passthrough instruction decoding' }
RSSimulator >> pushActiveContext [
	"Push Active Context On Top Of Its Own Stack bytecode."
	^ currentContext pushActiveContext
]

{ #category : #'passthrough instruction decoding' }
RSSimulator >> pushClosureCopyNumCopiedValues: numCopied numArgs: numArgs blockSize: blockSize [
	"Push Closure bytecode."
	^ currentContext pushClosureCopyNumCopiedValues: numCopied numArgs: numArgs blockSize: blockSize
]

{ #category : #'passthrough instruction decoding' }
RSSimulator >> pushConsArrayWithElements: numElements [
	"Push Cons Array of size numElements popping numElements items from the stack into the array bytecode."
	^ currentContext pushConsArrayWithElements: numElements
]

{ #category : #'passthrough instruction decoding' }
RSSimulator >> pushConstant: value [
	"Push Constant, value, on Top Of Stack bytecode."
	^ currentContext pushConstant: value
]

{ #category : #'passthrough instruction decoding' }
RSSimulator >> pushFullClosure: aCompiledBlock numCopied: numCopied [
	"Push Full Closure bytecode."
	^ currentContext pushFullClosure: aCompiledBlock numCopied: numCopied
]

{ #category : #'passthrough instruction decoding' }
RSSimulator >> pushLiteralVariable: anAssociation [
	"Push Contents Of anAssociation On Top Of Stack bytecode."
	^ currentContext pushLiteralVariable: anAssociation
]

{ #category : #'passthrough instruction decoding' }
RSSimulator >> pushNewArrayOfSize: numElements [ 
	"Push New Array of size numElements bytecode."
	^ currentContext pushNewArrayOfSize: numElements
]

{ #category : #'passthrough instruction decoding' }
RSSimulator >> pushReceiver [
	"Push Active Context's Receiver on Top Of Stack bytecode."
	^ currentContext pushReceiver
]

{ #category : #'passthrough instruction decoding' }
RSSimulator >> pushReceiverVariable: offset [
	"Push Contents Of the Receiver's Instance Variable Whose Index 
	is the argument, offset, On Top Of Stack bytecode."
	^ currentContext pushReceiverVariable: offset
]

{ #category : #'passthrough instruction decoding' }
RSSimulator >> pushRemoteTemp: remoteTempIndex inVectorAt: tempVectorIndex [
	"Push Contents at Offset in Temp Vector bytecode."
	^ currentContext pushRemoteTemp: remoteTempIndex inVectorAt: tempVectorIndex
]

{ #category : #'passthrough instruction decoding' }
RSSimulator >> pushTemporaryVariable: offset [

	^ currentContext pushTemporaryVariable: offset
]

{ #category : #'overwritten instruction decoding' }
RSSimulator >> quickSend: selector to: rcvr with: arguments lookupIn: lookupClass [
	
	"Send the given selector with arguments in an environment which closely resembles
	 the non-simulating environment, with an interjected unwind-protected block to catch
	 nonlocal returns.  Attention: don't get lost!  This beautiful method is originally due to
	 Hans-Martin Mosner."
	| oldSender contextToReturnTo result |
	contextToReturnTo := currentContext.
	[oldSender := thisContext sender swapSender: currentContext.
	 result := [currentContext object: rcvr perform: selector withArguments: arguments inClass: lookupClass] 
		on: RSRestartTracingNotification 
		do: [:e | 
			"Send self to the signaller of the notification to allow them to continue tracing using self."
			e resume: self].
	 thisContext sender swapSender: oldSender] ifCurtailed:
		[contextToReturnTo := thisContext sender receiver.	"The block context returning nonlocally"
		contextToReturnTo pc: contextToReturnTo previousPc.	"skip to front of return bytecode causing this unwind"
		contextToReturnTo willReturnTopFromMethod ifTrue:
			"If it was a returnTop, push the value to be returned.
			Otherwise the value is implicit in the bytecode"
			[contextToReturnTo push: (thisContext sender tempAt: 1)].
		thisContext swapSender: thisContext home sender.	"Make this block return to the method's sender"
		contextToReturnTo].
	contextToReturnTo push: result.
	^contextToReturnTo
]

{ #category : #'quick-stepping' }
RSSimulator >> quickStepDefaultCategories [
	
	quickSteppedCategories addAll: {'Kernel-'. 'Collections-'. 'Graphics-'}
]

{ #category : #'quick-stepping' }
RSSimulator >> quickSteppedCategories: anOrderedCollection [

	quickSteppedCategories := anOrderedCollection
]

{ #category : #babylonian }
RSSimulator >> recordAssertionHit: aNumber [
	
	recorder value: #assertionHit value: {aNumber}
]

{ #category : #babylonian }
RSSimulator >> recordProbeHit: aNumber [
	
	recorder value: #probeHit value: {aNumber}
]

{ #category : #'overwritten instruction decoding' }
RSSimulator >> send: selector super: superFlag numArgs: numArgs [
	
	"Simulate the action of bytecodes that send a message with selector, 
	 selector. The argument, superFlag, tells whether the receiver of the 
	 message was specified with 'super' in the source method. The arguments 
	 of the message are found in the top numArgs locations on the stack and 
	 the receiver just below them."

	| quick arguments lookupClass thisReceiver |
	"^ currentContext send: selector super: superFlag numArgs: numArgs"
	
	arguments := Array new: numArgs.
	numArgs to: 1 by: -1 do: [ :i | arguments at: i put: currentContext pop].
	thisReceiver := currentContext pop.
	lookupClass := superFlag
					ifTrue: [currentContext method methodClassAssociation value superclass]
					ifFalse: [currentContext objectClass: thisReceiver].
					
	"
	avoid signalling in simulateIfNeeded:additionalDepth: , because it somehow breaks everything (try BorderedMorph new as an example)
	This only happens when using RSProxyObjects as is done below.
	" 
	selector == #simulateIfNeeded:additionalDepth: ifTrue: [arguments at: 2 put: -1].
	
	quick := self shouldQuickStepForClass: lookupClass andSelector: selector.
	quick ~= #no ifTrue: [
		^ self doQuick: quick selector: selector rcvr: thisReceiver arguments: arguments lookupClass: lookupClass].
		
	currentContext shouldQuickStep ifTrue: [
		currentContext resetMarkForQuickStep.
		^ self quickSend: selector to: thisReceiver with: arguments lookupIn: lookupClass].
	^ self send: selector to: thisReceiver with: arguments lookupIn: lookupClass
]

{ #category : #'overwritten instruction decoding' }
RSSimulator >> send: selector to: rcvr with: arguments lookupIn: lookupClass [
	
	"Simulate the action of sending a message with selector and arguments
	 to rcvr. The argument, lookupClass, is the class in which to lookup the
	 message.  This is the receiver's class for normal messages, but for super
	 messages it will be some specific class related to the source method."

	| meth primIndex val ctxt |
	
	(meth := lookupClass lookupSelector: selector) ifNil:
		[^self send: #doesNotUnderstand:
				to: rcvr
				with: {(Message selector: selector arguments: arguments) lookupClass: lookupClass}
				lookupIn: lookupClass].
			
	"support for objects as methods, e.g., method wrappers"
	meth isCompiledMethod ifFalse: [
		"^ self quickSend: selector to: rcvr with: arguments lookupIn: lookupClass"
		"^self send: #valueWithReceiver:arguments: to: meth with: {rcvr. arguments} lookupIn: meth class"
		| quick |
		quick := self shouldQuickStepForClass: rcvr andSelector: selector.
		^ quick ~= #no 
			ifTrue: [self doQuick: quick selector: #valueWithReceiver:arguments: rcvr: meth arguments: {rcvr. arguments} lookupClass: meth class]
			ifFalse: [self send: #valueWithReceiver:arguments: to: meth with: {rcvr. arguments} lookupIn: meth class]].
			
	meth numArgs ~= arguments size ifTrue:
		[^currentContext error: 'Wrong number of arguments in simulated message ', selector printString].
	(primIndex := meth primitive) > 0 ifTrue:
		[val := self doPrimitive: primIndex method: meth receiver: rcvr args: arguments.
		 (currentContext isPrimFailToken: val) ifFalse:
			[^val]].
	(selector == #doesNotUnderstand: and: [lookupClass == ProtoObject]) ifTrue:
		[^self error: 'Simulated message ', arguments first selector, ' not understood'].
	
	"meth isCompiledMethod 
		ifTrue: ["ctxt := Context sender: currentContext receiver: rcvr method: meth arguments: arguments."]
		ifFalse: [ctxt := Context sender: self receiver: meth method: (meth class lookupSelector: #valueWithReceiver:arguments:) arguments: {rcvr. arguments}]."
	
	primIndex > 0 ifTrue:
		[ctxt failPrimitiveWith: val].
	^ctxt
]

{ #category : #'private quick-stepping' }
RSSimulator >> shouldClassBeQuickStepped: aClass [
	
	| lookupClassCategory |
	lookupClassCategory := aClass category.
	^ quickSteppedCategories anySatisfy: [:categoryPrefix | lookupClassCategory beginsWith: categoryPrefix]
]

{ #category : #'private quick-stepping' }
RSSimulator >> shouldQuickStepForClass: aClass andSelector: aSymbol [
	
	self flag: #todo. "need to always ALLOW BlockClosure for now, since it would otherwise immediately quickstep wrapped blocks"
	aClass == BlockClosure ifTrue: [^ #no].
	(SkippedSelectors includes: aSymbol) ifTrue: [^ #yesNotWrapped].
	(self shouldClassBeQuickStepped: aClass) ifTrue: [^ #yesWrapped].

	^ #no
]

{ #category : #private }
RSSimulator >> simulate: aBlock withRecorder: aRecorder [
	
	| simulationContext rootContext |
	aBlock hasMethodReturn ifTrue: [self error: 'simulation of blocks with ^ can run loose'].
	recorder := aRecorder.
	simulationContext := thisContext.
	currentContext := rootContext := aBlock asContext.
	currentContext pushArgs: Array new from: simulationContext.
	[currentContext notNil and: [currentContext ~~ simulationContext]] whileTrue: [
		"currentContext ~= rootContext" true ifTrue: [ | depth |
			"we need to calculate the depth here, since currentContext sender is nilled once it returns -> therefore loosing any chance of calculating the depth information"
			depth := depthCalculator calculateDepth: currentContext.
			aRecorder value: #step value: {currentContext . depth}].
		self simulateNextInstruction].
	^ currentContext ifNil: [nil] ifNotNil: [simulationContext pop]
]

{ #category : #private }
RSSimulator >> simulateNextInstruction [

	currentContext := currentContext interpretNextInstructionFor: self
]

{ #category : #private }
RSSimulator >> simulateWithExistingRecorder: aBlock additionalDepth: aNumber [
	
	| instance |
	instance := self class new.
	instance depthCalculator fixedOffset: (depthCalculator calculateDepth: currentContext) + aNumber.
	instance quickSteppedCategories: quickSteppedCategories.
	^ instance simulate: aBlock withRecorder: recorder
]

{ #category : #'passthrough instruction decoding' }
RSSimulator >> storeIntoLiteralVariable: anAssociation [ 
	"Store Top Of Stack Into Literal Variable Of Method bytecode."
	^ currentContext storeIntoLiteralVariable: anAssociation
]

{ #category : #'passthrough instruction decoding' }
RSSimulator >> storeIntoReceiverVariable: offset [ 
	"Store Top Of Stack Into Instance Variable Of Method bytecode."
	^ currentContext storeIntoReceiverVariable: offset
]

{ #category : #'passthrough instruction decoding' }
RSSimulator >> storeIntoRemoteTemp: remoteTempIndex inVectorAt: tempVectorIndex [
	"Store Top Of Stack And Store Into Offset of Temp Vector bytecode."
	^ currentContext storeIntoRemoteTemp: remoteTempIndex inVectorAt: tempVectorIndex
]

{ #category : #'passthrough instruction decoding' }
RSSimulator >> storeIntoTemporaryVariable: offset [ 
	"Store Top Of Stack Into Temporary Variable Of Method bytecode."
	^ currentContext storeIntoTemporaryVariable: offset
]

{ #category : #'passthrough instruction decoding' }
RSSimulator >> trapIfNotInstanceOf: behaviorOrArrayOfBehavior [
	"If the top of stack is not an instance of either the argument, or, if the argument is an Array,
	  any of the elements of the argument, send the class trap message to the current context."
	^ currentContext trapIfNotInstanceOf: behaviorOrArrayOfBehavior
]

{ #category : #'private quick-stepping' }
RSSimulator >> wrapArgument: arg [
	
	^ arg isBlock 
		ifFalse: [(self shouldClassBeQuickStepped: arg class) ifTrue: [arg] ifFalse: [RSProxyObject wrap: arg]] 
		ifTrue: [
			arg numArgs caseOf: {
				[0] -> [[RSSimulator simulateIfNeeded: arg additionalDepth: 0]].
				[1] -> [[:a1 | RSSimulator simulateIfNeeded: [arg value: a1] additionalDepth: 0]].
				[2] -> [[:a1 :a2 | RSSimulator simulateIfNeeded: [arg value: a1 value: a2] additionalDepth: 0]].
				[3] -> [[:a1 :a2 :a3 | RSSimulator simulateIfNeeded: [arg value: a1 value: a2 value: a3] additionalDepth: 0]].
				[4] -> [[:a1 :a2 :a3 :a4 | RSSimulator simulateIfNeeded: [arg value: a1 value: a2 value: a3 value: a4] additionalDepth: 0]].
				[5] -> [[:a1 :a2 :a3 :a4 :a5 | RSSimulator simulateIfNeeded: [arg value: a1 value: a2 value: a3 value: a4 value: a5] additionalDepth: 0]].
				[6] -> [[:a1 :a2 :a3 :a4 :a5 :a6 | RSSimulator simulateIfNeeded: [arg valueWithArguments: {a1. a2. a3. a4. a5. a6}] additionalDepth: 0]].
				[7] -> [[:a1 :a2 :a3 :a4 :a5 :a6 :a7 | RSSimulator simulateIfNeeded: [arg valueWithArguments: {a1. a2. a3. a4. a5. a6. a7}] additionalDepth: 0]].
				[8] -> [[:a1 :a2 :a3 :a4 :a5 :a6 :a7 :a8 | RSSimulator simulateIfNeeded: [arg valueWithArguments: {a1. a2. a3. a4. a5. a6. a7. a8}] additionalDepth: 0]].
				[9] -> [[:a1 :a2 :a3 :a4 :a5 :a6 :a7 :a8 :a9 | RSSimulator simulateIfNeeded: [arg valueWithArguments: {a1. a2. a3. a4. a5. a6. a7. a8. a9}] additionalDepth: 0]].
				[10] -> [[:a1 :a2 :a3 :a4 :a5 :a6 :a7 :a8 :a9 :a10 | RSSimulator simulateIfNeeded: [arg valueWithArguments: {a1. a2. a3. a4. a5. a6. a7. a8. a9. a10}] additionalDepth: 0]].
				[11] -> [[:a1 :a2 :a3 :a4 :a5 :a6 :a7 :a8 :a9 :a10 :a11 | RSSimulator simulateIfNeeded: [arg valueWithArguments: {a1. a2. a3. a4. a5. a6. a7. a8. a9. a10. a11}] additionalDepth: 0]].
				[12] -> [[:a1 :a2 :a3 :a4 :a5 :a6 :a7 :a8 :a9 :a10 :a11 :a12 | RSSimulator simulateIfNeeded: [arg valueWithArguments: {a1. a2. a3. a4. a5. a6. a7. a8. a9. a10. a11. a12}] additionalDepth: 0]].
				[13] -> [[:a1 :a2 :a3 :a4 :a5 :a6 :a7 :a8 :a9 :a10 :a11 :a12 :a13 | RSSimulator simulateIfNeeded: [arg valueWithArguments: {a1. a2. a3. a4. a5. a6. a7. a8. a9. a10. a11. a12. a13}] additionalDepth: 0]].
				[14] -> [[:a1 :a2 :a3 :a4 :a5 :a6 :a7 :a8 :a9 :a10 :a11 :a12 :a13 :a14 | RSSimulator simulateIfNeeded: [arg valueWithArguments: {a1. a2. a3. a4. a5. a6. a7. a8. a9. a10. a11. a12. a13. a14}] additionalDepth: 0]].
				"[15] -> [[:a1 :a2 :a3 :a4 :a5 :a6 :a7 :a8 :a9 :a10 :a11 :a12 :a13 :a14 :a15 | RSSimulator simulateIfNeeded: [arg valueWithArguments: {a1. a2. a3. a4. a5. a6. a7. a8. a9. a10. a11. a12. a13. a14. a15}] additionalDepth: 0]]."
			} otherwise: [self error: 'Blocks with more than 14 arguments are not currently supported.']]
]
