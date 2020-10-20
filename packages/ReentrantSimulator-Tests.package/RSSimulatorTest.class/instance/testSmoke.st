as yet unclassified
testSmoke
	
	| stream simulator |
	stream := NullStream new.
	simulator := RSSimulator new.
	simulator config: RSSimulatorConfiguration babylonian.
	{
		[Browser open topView delete] . 
		[Preferences standardButtonFont]	
	} do: [:block |
		simulator trace: block on: stream]