instance creation
wrap: anObject
	
	^ anObject isRSProxyObject ifTrue: [anObject] ifFalse: [self new rsSetProxiedObject: anObject]