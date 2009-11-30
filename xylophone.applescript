global arduino

on run
	
	-- Start transmit
	tell application "Transmit"
		
	end tell
	
	-- Select port where Arduino is located
	set device to choose from list (serialport list)
	set arduino to serialport open device bps rate 9600 data bits 8 parity 0 stop bits 1 handshake 0
	if arduino is equal to -1 then
		display dialog " could not open port "
	end if
	delay 2
	
end run

on quit
	serialport close arduino
	continue quit
end quit

on idle
	set num to serialport bytes available arduino
	if num is greater than 0 then
		set x to serialport read arduino for 1
		if x is equal to "r" then
			say "Should start recording."
			
			try
				tell application "CamSpinner"
					start recording
				end tell
			on error
				say "Start recording failed."
			end try
			
		else if x is equal to "s" then
			say "Should stop recording and copy video."
			try
				
				tell application "CamSpinner"
					
					set video_file to stop recording
					
					-- Make an atomic copy of the video file.
					-- It will be rsynced later to webserver.
					tell application "Finder"
						copy file video_file to folder "Rsync" of disk "Macintosh HD"
						move video_file to trash
						empty trash
					end tell
					
					--tell application "Transmit"
					
					--	set SuppressAppleScriptAlerts to true
					--	make new document at before front document
					
					--	tell current session of document 1
					
					--		if (connect to favorite with name "xylophone") then
					--			upload item video_file
					--		else
					--			say "Could not connect to xylophone server."
					--		end if
					
					--	end tell
					--end tell
					
				end tell
				-- CamSpinner
				
			on error
				say "Stop recording failed."
			end try
		end if
	end if
	return 1
end idle