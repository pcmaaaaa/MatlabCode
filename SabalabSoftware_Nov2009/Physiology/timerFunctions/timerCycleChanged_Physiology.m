function timerCycleChanged_Physiology
	global gh state
	
	if state.cycle.inputTracksOutput
		set(...
			[gh.advancedCycleGui.recordingDuration]...
			, 'Enable', 'off')
	else
		set(...
			[gh.advancedCycleGui.recordingDuration]...
			, 'Enable', 'on')
	end
	