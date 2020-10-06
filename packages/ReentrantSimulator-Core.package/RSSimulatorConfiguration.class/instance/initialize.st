initialize-release
initialize
	


	super initialize.
	
	quickCategories := IdentityDictionary new.
	quickClasses := IdentityDictionary new.
	quickSelectors := IdentityDictionary new.
	quickClassSelectors := IdentityDictionary new.
	wrapBlocks := false.
	wrapOther := false