function get-disco-status --argument sing_env disco_env
	set -l servicetype sous-server
  set -l host sous.otenv.com
	set -l sing_url http://singularity-{$sing_env}.otenv.com/
  set -l disco_urls (cygnus -x 1 $sing_url | grep {$disco_env}"-discovery" | awk '{ print "http://" $3 ":" $4 "/announcement?serviceType='$servicetype'" }')
  echo DISCOVERY
  for du in $disco_urls
    echo $du
    curl $du
    echo
  end

  set -l fd_urls (cygnus -x 1 $sing_url | grep {$disco_env}"-frontdoor" | awk '{ print "http://" $3 ":" $4 "/servers" }')
  echo FRONTDOOR
  for fd in $fd_urls
    echo $fd $host
    curl -H "Host:$host" $fd
    echo
  end
end
