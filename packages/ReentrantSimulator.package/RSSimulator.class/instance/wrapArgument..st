private quick-stepping
wrapArgument: arg
	
	^ arg isBlock 
		ifFalse: [(self shouldClassBeQuickStepped: arg class) ifTrue: [arg] ifFalse: [RSProxyObject wrap: arg]] 
		ifTrue: [
			arg numArgs caseOf: {
				[0] -> [[RSSimulator simulateIfNeeded: arg additionalDepth: 0]].
				[1] -> [[:a1 | RSSimulator simulateIfNeeded: [arg value: a1] additionalDepth: 0]].
				[2] -> [[:a1 :a2 | RSSimulator simulateIfNeeded: [arg value: a1 value: a2] additionalDepth: 0]].
				[3] -> [[:a1 :a2 :a3 | RSSimulator simulateIfNeeded: [arg value: a1 value: a2 value: a3] additionalDepth: 0]].
				[4] -> [[:a1 :a2 :a3 :a4 | RSSimulator simulateIfNeeded: [arg value: a1 value: a2 value: a3 value: a4] additionalDepth: 0]].
				[5] -> [[:a1 :a2 :a3 :a4 :a5 | RSSimulator simulateIfNeeded: [arg value: a1 value: a2 value: a3 value: a4 value: a5] additionalDepth: 0]].
				[6] -> [[:a1 :a2 :a3 :a4 :a5 :a6 | RSSimulator simulateIfNeeded: [arg valueWithArguments: {a1. a2. a3. a4. a5. a6}] additionalDepth: 0]].
				[7] -> [[:a1 :a2 :a3 :a4 :a5 :a6 :a7 | RSSimulator simulateIfNeeded: [arg valueWithArguments: {a1. a2. a3. a4. a5. a6. a7}] additionalDepth: 0]].
				[8] -> [[:a1 :a2 :a3 :a4 :a5 :a6 :a7 :a8 | RSSimulator simulateIfNeeded: [arg valueWithArguments: {a1. a2. a3. a4. a5. a6. a7. a8}] additionalDepth: 0]].
				[9] -> [[:a1 :a2 :a3 :a4 :a5 :a6 :a7 :a8 :a9 | RSSimulator simulateIfNeeded: [arg valueWithArguments: {a1. a2. a3. a4. a5. a6. a7. a8. a9}] additionalDepth: 0]].
				[10] -> [[:a1 :a2 :a3 :a4 :a5 :a6 :a7 :a8 :a9 :a10 | RSSimulator simulateIfNeeded: [arg valueWithArguments: {a1. a2. a3. a4. a5. a6. a7. a8. a9. a10}] additionalDepth: 0]].
				[11] -> [[:a1 :a2 :a3 :a4 :a5 :a6 :a7 :a8 :a9 :a10 :a11 | RSSimulator simulateIfNeeded: [arg valueWithArguments: {a1. a2. a3. a4. a5. a6. a7. a8. a9. a10. a11}] additionalDepth: 0]].
				[12] -> [[:a1 :a2 :a3 :a4 :a5 :a6 :a7 :a8 :a9 :a10 :a11 :a12 | RSSimulator simulateIfNeeded: [arg valueWithArguments: {a1. a2. a3. a4. a5. a6. a7. a8. a9. a10. a11. a12}] additionalDepth: 0]].
				[13] -> [[:a1 :a2 :a3 :a4 :a5 :a6 :a7 :a8 :a9 :a10 :a11 :a12 :a13 | RSSimulator simulateIfNeeded: [arg valueWithArguments: {a1. a2. a3. a4. a5. a6. a7. a8. a9. a10. a11. a12. a13}] additionalDepth: 0]].
				[14] -> [[:a1 :a2 :a3 :a4 :a5 :a6 :a7 :a8 :a9 :a10 :a11 :a12 :a13 :a14 | RSSimulator simulateIfNeeded: [arg valueWithArguments: {a1. a2. a3. a4. a5. a6. a7. a8. a9. a10. a11. a12. a13. a14}] additionalDepth: 0]].
				"[15] -> [[:a1 :a2 :a3 :a4 :a5 :a6 :a7 :a8 :a9 :a10 :a11 :a12 :a13 :a14 :a15 | RSSimulator simulateIfNeeded: [arg valueWithArguments: {a1. a2. a3. a4. a5. a6. a7. a8. a9. a10. a11. a12. a13. a14. a15}] additionalDepth: 0]]."
			} otherwise: [self error: 'Blocks with more than 14 arguments are not currently supported.']]