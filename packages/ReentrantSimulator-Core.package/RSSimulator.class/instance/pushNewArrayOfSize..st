passthrough instruction decoding
pushNewArrayOfSize: numElements 
	"Push New Array of size numElements bytecode."
	^ currentContext pushNewArrayOfSize: numElements