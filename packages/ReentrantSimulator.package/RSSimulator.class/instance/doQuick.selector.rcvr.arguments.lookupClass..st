private quick-stepping
doQuick: type selector: selector rcvr: rcvr arguments: arguments lookupClass: lookupClass
	
	type caseOf: {
		[#yesNotWrapped] ->[ | result |
			"no need to do any shenanigans here, since the Tracer is already modified to restart tracing when running user code"
			result := self quickSend: selector to: rcvr with: arguments lookupIn: lookupClass.
			selector caseOf: {
				[#bpAssertAfter:that:forAssertion:given:inContext:] -> [self recordAssertionHit: arguments third].
				[#bpTrace:forProbe:inContext:] -> [self recordProbeHit: arguments second].
				[#bpTrace:through:forProbe:inContext:] -> [self recordProbeHit: arguments third].
				[#bpTraceAssignmentOf:before:forProbe:inContext:] -> [self recordProbeHit: arguments third].
			} otherwise: [].
			^ result].
		[#yesWrapped] -> [ | args |
			args := arguments collect: [:arg | self wrapArgument: arg].
			^ self quickSend: selector to: rcvr with: args lookupIn: lookupClass].
	}