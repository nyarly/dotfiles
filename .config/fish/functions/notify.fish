function notify --argument title message group
	if type -q terminal-notifier
    terminal-notifier -title "$title" -message "$message" -group "$group" ^/dev/null > /dev/null
  else if type -q notify-send
    notify-send $title $message ^/dev/null > /dev/null
  else
    return 1
  end
end
