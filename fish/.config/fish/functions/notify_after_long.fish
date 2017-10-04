function notify_after_long --on-event fish_postexec --argument last_command
	set -gx CMD_SECONDS 0
  if test -z $CMD_DURATION
    return 0
  end
  switch $last_command
  case 'nvim*' 'man*' 'less*'
    return
  end
  #set CMD_SECONDS (echo $CMD_DURATION | awk 'BEGIN { FS="." } ; { print $1 }')
  set -gx CMD_SECONDS (math $CMD_DURATION/1000)
  if [ $CMD_SECONDS -gt 15 ]
    notify "Long command complete" "The long running command\n  $last_command\n has finished.\nTotal duration: $CMD_SECONDS s"
    echo \a
  end
end
