overwritten instruction decoding
send: selector super: superFlag numArgs: numArgs
	
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