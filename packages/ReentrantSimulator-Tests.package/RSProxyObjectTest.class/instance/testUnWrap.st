tests
testUnWrap
	
	| proxy proxee |
	proxee := Morph new.
	proxy := RSProxyObject wrap: proxee.
	
	self assert: proxy isRSProxyObject.
	self deny: proxee isRSProxyObject.
	
	proxy rsProxyUnwrap.
	
	self deny: proxy isRSProxyObject.
	self deny: proxee isRSProxyObject.
	self assert: proxy == proxee