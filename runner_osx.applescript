try
	tell application "Finder"
		set win_path to POSIX path of ((path to me as text) & "::")
		set win_folder to POSIX file win_path as alias
		set folder_items to {}
		repeat with folder_item in (every item of win_folder whose name starts with "pt" or name starts with "orchestrator")
			if class of folder_item is folder then
				set end of folder_items to name of folder_item
			end if
		end repeat
		set folders_length to the length of folder_items
	end tell
	if folders_length is greater than 0 then
		set micro_count to 0
		display dialog "Command" default answer "npm run dev" buttons {"Continue", "Cancel"} default button 1 with icon note
		if the button returned of the result is "Continue" then
			set command to text returned of the result
			repeat with micro in (get items of folder_items)
				set micro_count to micro_count + 1
				tell application "Terminal"
					if not (exists window 1) then reopen
					activate
					set position of front window to {1, 1}
					do script "cd " & win_path & micro in front window
					delay 0.2
					do script command in front window
					delay 0.5
					if folders_length is greater than micro_count then tell application "System Events" to keystroke "t" using {command down}
				end tell
			end repeat
		end if
	else
		display dialog "No micros" buttons {"Ok"} default button 1 with icon caution
	end if
on error message
	display dialog message buttons {"Ok", "Cancel"} default button 1 with icon note
end try



