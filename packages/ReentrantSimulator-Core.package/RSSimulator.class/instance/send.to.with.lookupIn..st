overwritten instruction decoding
send: selector to: rcvr with: arguments lookupIn: lookupClass
	
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
		quick := self config shouldQuickStepForClass: rcvr class andSelector: selector.
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