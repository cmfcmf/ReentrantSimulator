passthrough instruction decoding
pushConstant: value
	"Push Constant, value, on Top Of Stack bytecode."
	^ currentContext pushConstant: value