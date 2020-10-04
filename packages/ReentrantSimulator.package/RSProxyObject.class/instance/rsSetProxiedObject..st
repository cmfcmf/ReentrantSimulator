proxy
rsSetProxiedObject: anObject
	
	"use a long-ish / unconventional method name on purpose, so that we don't accidentally overwrite a method with the same name on our proxiedObject."
	
	proxiedObject := anObject.
	^ self "explicitly return self, as expected by class-side #wrap:"