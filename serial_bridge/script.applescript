-- Sample connection attachment script for Serial Bridge.
--
-- 2005-03-29 Original. (Matt Bendiksen)
-- 2005-04-01 Fixed event timeout bugs. (Matt Bendiksen)

-----------
-- 
on MyProcessSerialData(arduino)
	tell application "Serial Bridge"
		
		-- 6 bytes is the shortest possible command we can receive
		wait for data from source arduino to count 6
		--delay 1
		
		set incoming to read string from source arduino
		--log incoming using type "Sample"
		
		-- Incoming protocol is command:parameter
		set previous to AppleScript's text item delimiters
		set AppleScript's text item delimiters to ":"
		set temp to text items of incoming
		set AppleScript's text item delimiters to previous
		set command to item 1 of temp
		set parameter to item 2 of temp
		
		-- Remove trailing newline		
		set parameter to text 1 thru ((offset of ASCII character 10 in parameter) - 2) of parameter
		
		if command is equal to "record" then
			try
				tell application "QuickTime Player"
					activate
					new movie recording
					start first document
				end tell
				log "Start recording" using type "Command"
			on error
				log "Start recording failed" using type "Command"
			end try
		else if command is equal to "stop" then
			try
				tell application "QuickTime Player"
					stop first document
					set video_file to file of first document as alias
					close first document
					tell application "Finder"
						set name of video_file to parameter
						move video_file to folder "Users:tuupola:Movies:rsync" of disk "Macintosh HD" with replacing
					end tell
					--say "Stop recording."
					
				end tell
				-- QuickTime Player
				
			on error
				log "Stop recording failed" using type "Error"
			end try
			-- Notify Arduino we are done
			send to source arduino string "c"
			
		else if command is equal to "debug" then
			log parameter using type "Debug"
		end if
		
	end tell
end MyProcessSerialData

-----------
-- Serial Bridge will call the startCommunication() subroutine after it has opened
-- the serial port connection for this connection. It is only called after the serial
-- port connection has been opened, shortly after Serial Bridge launches or if
-- the user presses the Reload Script button.
--
on startCommunication(connectionName)
	tell application "Serial Bridge"
		
		-- Loop forever: wait for data, read it, process it, and optionally send
		-- out serial data.
		repeat while true
			try
				set maxTimeoutDelay to 8947848 -- 103.56 days (hex 0x00888888)
				with timeout of maxTimeoutDelay seconds
					my MyProcessSerialData(connectionName)
				end timeout
			on error number errNum
				(* Log timeout errors (-1712) but continue processing loop. Without
				 * handling this error, the script would throw out of the repeat loop
				 * and terminate if any of the script calls were to throw a timeout error.
				 * Normally, if there was a timeout error thrown you would want
				 * to continue processing your main loop in an attempt to get back
				 * in syncronization with the hardware. By catching this error we
				 * will do exactly this and continue to process our script repeat loop.
				 *)
				if errNum is -1712 then
					log "timeout waiting for serial data" using type "Error"
				else if errNum is -1708 then
					log "AppleEvent not handled" using type "Error"
					return -- fatal error; exit script processing
				else if errNum is -128 then
					log "connection script aborted" using type "Error"
					return -- fatal error; exit script processing
				else
					log "error " & errNum & " inside MyProcessSerialData()" using type "Error"
					--return -- maybe fatal error; exit script processing
				end if
			end try
		end repeat
	end tell
end startCommunication

