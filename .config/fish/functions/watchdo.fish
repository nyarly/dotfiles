function watchdo
	type -q fswatch; or begin
    echo "Need fswatch"
    return 1
  end

  set -l pattern $argv[1]
  set -l command $argv[2..-1]

  echo '>' $command
  eval $command

  while true do
    echo Watching $pattern
    fswatch -1ri "$pattern" -e '.*' .

    eval $command
    if [ $status -eq 0 ]
      notify Success "$command"
    else
      notify Failure "$command"
    end
  end
end
