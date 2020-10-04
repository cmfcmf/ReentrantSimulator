overwritten instruction decoding
doPrimitive: primitiveIndex method: meth receiver: receiver args: arguments
	
	"Simulate a primitive method whose index is primitiveIndex.  The simulated receiver and
	 arguments are given as arguments to this message. If successful, push result and return
	 resuming context, else ^ {errCode, PrimitiveFailToken}. Any primitive which provokes
	 execution needs to be intercepted and simulated to avoid execution running away."

	primitiveIndex = 84 ifTrue: "afr 9/11/1998 19:50 & eem 8/18/2009 17:04" "Object>>perform:withArguments:"
		[^self send: arguments first to: receiver with: (arguments at: 2) lookupIn: (currentContext objectClass: receiver)].
	
	^ currentContext doPrimitive: primitiveIndex method: meth receiver: receiver args: arguments