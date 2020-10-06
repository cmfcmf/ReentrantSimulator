instance creation
default
	
	| config |
	config := self new.
	config quickCategories addAll: {'Kernel-' -> #yesWrapped. 'Collections-' -> #yesWrapped. 'Graphics-' -> #yesWrapped}.
	config wrapBlocks: true.
	config wrapNonBlocks: true.
	^ config