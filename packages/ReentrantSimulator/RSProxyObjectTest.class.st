Class {
	#name : #RSProxyObjectTest,
	#superclass : #TestCase,
	#category : #'ReentrantSimulator-Tests'
}

{ #category : #tests }
RSProxyObjectTest >> testNuke [
	
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
]

{ #category : #tests }
RSProxyObjectTest >> testPassesThroughMessages [
	
	| proxy proxee |
	proxee := Morph new.
	proxy := RSProxyObject wrap: proxee.
	
	self assert: proxee color equals: proxy color.
]

{ #category : #tests }
RSProxyObjectTest >> testUnWrap [
	
	| proxy proxee |
	proxee := Morph new.
	proxy := RSProxyObject wrap: proxee.
	
	self assert: proxy isRSProxyObject.
	self deny: proxee isRSProxyObject.
	
	proxy rsProxyUnwrap.
	
	self deny: proxy isRSProxyObject.
	self deny: proxee isRSProxyObject.
	self assert: proxy == proxee
]

{ #category : #tests }
RSProxyObjectTest >> testWrapsCorrectly [
	
	| proxy proxee |
	proxee := Morph new.
	proxy := RSProxyObject wrap: proxee.
	
	self assert: proxy isRSProxyObject.
	self deny: proxee isRSProxyObject.
	self assert: proxy = proxee.
	self deny: proxy ~= proxee.
	self assert: proxy identityHash == proxee identityHash.
	self assert: proxy ~~ proxee. "limitation of our proxy implementation"
]
