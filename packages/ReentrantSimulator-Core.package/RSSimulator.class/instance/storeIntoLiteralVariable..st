passthrough instruction decoding
storeIntoLiteralVariable: anAssociation 
	"Store Top Of Stack Into Literal Variable Of Method bytecode."
	^ currentContext storeIntoLiteralVariable: anAssociation