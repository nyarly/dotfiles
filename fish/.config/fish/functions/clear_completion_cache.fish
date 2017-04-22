function clear_completion_cache --description 'Clears the completion for <program> in the current directory' --argument program
	set -l cache_dir "$HOME/.config/fish/completion_cache/$program"
  set -l hashed_pwd (pwd | md5sum --text -)
  set -l cache_file "$cache_dir/$hashed_pwd"
  rm -f $cache_file
end
