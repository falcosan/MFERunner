try
	tell application "Finder"
		set win_path to POSIX path of ((path to me as text) & "::")
		set win_folder to POSIX file win_path as alias
		set folder_items to {}
		repeat with folder_item in (every item of win_folder whose name starts with "pt" or name starts with "orchestrator")
			if class of folder_item is folder then set end of folder_items to name of folder_item
		end repeat
	end tell
	if length of folder_items is greater than 0 then
		set app_count to 0
		set command_dialog to display dialog "Command" default answer "npm run dev" with icon note
		if the button returned of the command_dialog is "OK" then
			set command to text returned of the result
			set folder_items to choose from list folder_items default items folder_items with prompt "Apps" with multiple selections allowed
			repeat with app_item in folder_items
				set app_count to app_count + 1
				tell application "Terminal"
					if not (exists window 1) then reopen
					activate
					set position of front window to {1, 1}
					do script "cd " & win_path & app_item in front window
					delay 0.2
					do script command in front window
					delay 0.5
					if length of folder_items is greater than app_count then
						try
							tell application "System Events"
								keystroke "t" using command down
							end tell
						on error
							do script ""
							activate
						end try
					end if
				end tell
			end repeat
		end if
	else
		display dialog "No apps" with icon caution
	end if
on error errorMessage number errorNumber
	if errorNumber is not equal to -128 then display dialog errorMessage with icon note
end try