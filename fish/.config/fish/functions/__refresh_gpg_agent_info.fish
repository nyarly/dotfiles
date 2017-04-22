function __refresh_gpg_agent_info --description 'Reload ~/.gpg-agent-info'
	cat ~/.gpg-agent-info | sed 's/=/ /' | while read key value
        #echo $key $$key "->" $value
  set -e $key
  set -U -x $key "$value"
end
end
