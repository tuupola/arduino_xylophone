-- Globals are ugly but so is my AppleScript-fu
global arduino
global incoming
global command
global parameter

on run
	-- Reset everything
	set incoming to ""
	set command to ""
	set parameter to ""
	
	-- Select port where Arduino is located
	set device to choose from list (serialport list)
	set arduino to serialport open device bps rate 19200 data bits 8 parity 0 stop bits 1 handshake 0
	if arduino is equal to -1 then
		display dialog " could not open port "
	end if
	delay 2
	say "Ding"
end run

on quit
	serialport close arduino
	continue quit
end quit

on idle
	
	set num to serialport bytes available arduino
	if num is greater than 0 then
		
		-- Protocol looks like command:parameter<newline>
		set incoming to serialport read arduino
		set temp to split(incoming, ":")
		set command to item 1 of temp
		set parameter to item 2 of temp
		set incoming to ""
		--display dialog command & " - " & parameter
		
		if command is equal to "record" then
			set command to ""
			
			try
				tell application "QuickTime Player"
					activate
					new movie recording
					start first document
				end tell
				say "Start recording."
			on error
				say "Start recording failed."
			end try
			
		else if command is equal to "stop" then
			set command to ""
			
			try
				
				tell application "QuickTime Player"
					
					say "Stop recording."
					
					stop first document
					set video_file to file of first document as alias
					close first document
					tell application "Finder"
						set name of video_file to "xxx.mov"
						move video_file to folder "Users:tuupola:Movies:rsync" of disk "Macintosh HD" with replacing
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
			
			-- Notify Arduino we are done
			serialport write "c" to arduino
			
		else if command is equal to "debug" then
			set command to ""
			log parameter
			say parameter
		end if
	end if
	return 1
end idle


on split(input, delimiter)
	set previous to AppleScript's text item delimiters
	set AppleScript's text item delimiters to delimiter
	set output to text items of input
	set AppleScript's text item delimiters to previous
	return output
end split