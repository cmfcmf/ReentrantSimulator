testing
shouldClassBeQuickStepped: aClass
	
	| lookupClassCategory |
	quickClasses at: aClass ifPresent: [:type | ^ type].
	lookupClassCategory := aClass category.
	quickCategories associationsDo: [:entry | (lookupClassCategory beginsWith: entry key) ifTrue: [^ entry value]].
	^ #no