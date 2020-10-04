tests
testPassesThroughMessages
	
	| proxy proxee |
	proxee := Morph new.
	proxy := RSProxyObject wrap: proxee.
	
	self assert: proxee color equals: proxy color.