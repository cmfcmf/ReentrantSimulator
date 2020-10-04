tests
testWrapsCorrectly
	
	| proxy proxee |
	proxee := Morph new.
	proxy := RSProxyObject wrap: proxee.
	
	self assert: proxy isRSProxyObject.
	self deny: proxee isRSProxyObject.
	self assert: proxy = proxee.
	self deny: proxy ~= proxee.
	self assert: proxy identityHash == proxee identityHash.
	self assert: proxy ~~ proxee. "limitation of our proxy implementation"