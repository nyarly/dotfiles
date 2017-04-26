function __refresh_gpg_agent_info --description 'Reload ~/.gpg-agent-info'
	if test ! -c $GPG_TTY
    set -x GPG_TTY (tty)
  end
	cat ~/.gpg-agent-info | sed 's/=/ /' | while read key value
        #echo $key $$key "->" $value
  set -e $key
  set -U -x $key "$value"
end
end
