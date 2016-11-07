function done --on-event fish_prompt
	if test $CMD_DURATION
		# Store duration of last command
		set duration (echo "$CMD_DURATION 1000" | awk '{printf "%.3fs", $1 / $2}')

		# OS X notification when a command takes longer than notify_duration
		set notify_duration 10000
		set exclude_cmd "zsh|bash|less|man|more|ssh|drush php"
		if begin
				test $CMD_DURATION -gt $notify_duration
				and echo $history[1] | grep -vqE "^($exclude_cmd).*"
			end

			# Only show the notification if iTerm is not focused
			echo "
				tell application \"System Events\"
					set activeApp to name of first application process whose frontmost is true
					if \"iTerm\" is not in activeApp then
						display notification \"Finished in $duration\" with title \"$history[1]\"
					end if
				end tell
				" | osascript
		end
	end
end
