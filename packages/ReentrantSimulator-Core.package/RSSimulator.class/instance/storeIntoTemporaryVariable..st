passthrough instruction decoding
storeIntoTemporaryVariable: offset 
	"Store Top Of Stack Into Temporary Variable Of Method bytecode."
	^ currentContext storeIntoTemporaryVariable: offset