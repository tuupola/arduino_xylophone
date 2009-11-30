global portRef

on run
	set device to choose from list (serialport list)
	set portRef to serialport open device bps rate 9600 data bits 8 parity 0 stop bits 1 handshake 0
	if portRef is equal to -1 then
		display dialog " could not open port "
	end if
	delay 2
end run

on quit
	serialport close portRef
	continue quit
end quit

on idle
	set num to serialport bytes available portRef
	if num is greater than 0 then
		set x to serialport read portRef for 1
		if x is equal to "r" then
			say "Should start recording..."
			
			try
				tell application "CamSpinner"
					start recording
				end tell
			on error
				say "Start recording failed."
			end try
			
		else if x is equal to "s" then
			say "Should stop recording and upload video."
			try
				
				tell application "CamSpinner"
					
					set theFile to stop recording
					
					-- tell application "Finder"
					--	copy file theFile to folder "Backup" of disk "Backup HD"
					--	move theFile to trash
					--	empty trash -- WARNING: this command deletes everything in your Trash!
					-- end tell
					
				end tell
				
			on error
				say "Stop recording failed."
			end try
		end if
	end if
	return 1
end idle