function histfunc --argument number name
	if [ -z $number ]
    echo "$0 <number> is required"
  end
  if [ -z $name ]
    echo "$0 <name> is required"
  end

  if [ -z "$number" -o -z "$name" ]
    return 1
  end

	history | head -n $number >> ~/.config/fish/functions/{$name}.fish
  funced $name
end
