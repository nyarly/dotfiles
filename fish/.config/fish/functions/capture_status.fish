function capture_status --on-event fish_prompt
	set -gx LAST_STATUS $status
end
