function _run_fasd --on-event fish_preexec
	if type -q fasd
    fasd --proc (fasd --sanitize $argv | tr -s ' ' \n) > /dev/null ^&1
  end
end
