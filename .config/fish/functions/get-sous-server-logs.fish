function get-sous-server-logs --description 'Get singularity logs from http://singularity-<sing>.otenv.com for .*<server>.*' --argument sing server
	set -l sing_url http://singularity-{$sing}.otenv.com/
  set -l server_line (cygnus -x 1 $sing_url | grep "sous-server.*"{$server}".*")
  echo $server_line
  set -l req (echo $server_line | awk '{ print $1 }')
  set -l dep (echo $server_line | awk '{ print $2 }')
  echo $req
  echo $dep
  palomino get-log --url $sing_url $req $dep
end
