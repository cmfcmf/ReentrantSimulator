tests
testNuke
	
	| proxy proxee |
	proxee := Morph new.
	
	proxy := RSProxyObject wrap: proxee.
	
	self assert: proxy isRSProxyObject.
	self deny: proxee isRSProxyObject.
	
	self assert: RSProxyObject exists.
	RSProxyObject nuke.
	self deny: RSProxyObject exists.
	
	self deny: proxy isRSProxyObject.
	self deny: proxee isRSProxyObject.
	self assert: proxy == proxee