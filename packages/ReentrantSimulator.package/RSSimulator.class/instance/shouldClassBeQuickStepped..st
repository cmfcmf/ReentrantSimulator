private quick-stepping
shouldClassBeQuickStepped: aClass
	
	| lookupClassCategory |
	lookupClassCategory := aClass category.
	^ quickSteppedCategories anySatisfy: [:categoryPrefix | lookupClassCategory beginsWith: categoryPrefix]