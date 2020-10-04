"
I am a proxy that forwards all message sends to my proxiedObject.
Before forwarding a message, I signal a RSRestartTracingNotification to potentially re-enter simulation for the duration of the message send to my proxiedObject if a reentrant simulator is currently active.

I should behave nearly identical to an my instance of proxiedObject, except when sending #== or #~=.

To create a new instance of myself, i.e., to wrap an object with myself, send #wrap: to my class.
I will take care of not wrapping instances of myself.
"
Class {
	#name : #RSProxyObject,
	#superclass : #ProtoObject,
	#instVars : [
		'proxiedObject'
	],
	#category : #'ReentrantSimulator-Core'
}

{ #category : #'instance creation' }
RSProxyObject class >> exists [

	self allInstancesDo: [:proxy | ^ true].
	^ false
]

{ #category : #'instance creation' }
RSProxyObject class >> nuke [
	
	self allInstancesDo: [:proxy | proxy rsProxyUnwrap]
]

{ #category : #'instance creation' }
RSProxyObject class >> wrap: anObject [
	
	^ anObject isRSProxyObject ifTrue: [anObject] ifFalse: [self new rsSetProxiedObject: anObject]
]

{ #category : #'system primitives' }
RSProxyObject >> doesNotUnderstand: aMessage [
	
	| arguments selector |
	
	proxiedObject ifNil: [Error signal: 'empty proxy'].
	selector := aMessage selector.
	arguments := aMessage arguments.
	^ RSSimulator simulateIfNeeded: [
		"we cannot use aMessage >> #sendTo: here, since that causes an infinite loop."
		proxiedObject perform: selector withArguments: arguments] additionalDepth: 0
]

{ #category : #comparing }
RSProxyObject >> identityHash [

	^ proxiedObject identityHash 
]

{ #category : #proxy }
RSProxyObject >> isRSProxyObject [

	^ true
]

{ #category : #proxy }
RSProxyObject >> rsProxyUnwrap [

	self becomeForward: proxiedObject
]

{ #category : #proxy }
RSProxyObject >> rsSetProxiedObject: anObject [
	
	"use a long-ish / unconventional method name on purpose, so that we don't accidentally overwrite a method with the same name on our proxiedObject."
	
	proxiedObject := anObject.
	^ self "explicitly return self, as expected by class-side #wrap:"
]
