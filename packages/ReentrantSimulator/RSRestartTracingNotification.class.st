Class {
	#name : #RSRestartTracingNotification,
	#superclass : #Notification,
	#category : #'ReentrantSimulator-Core'
}

{ #category : #'as yet unclassified' }
RSRestartTracingNotification >> isRSProxyObject [
	
	self flag: #todo. "not sure why/if this is needed"
	^ true
]
