function __cache_or_get -a program get_cmd
  set -l cache_dir "$HOME/.config/fish/completion_cache/$program"
  set -l hashed_pwd (pwd | md5sum --text -)
  set -l cache_file "$cache_dir/$hashed_pwd"
  mkdir -p $cache_dir

  if not test -f "$cache_file"
    eval $get_cmd > "$cache_file"
  end
  cat "$cache_file"
end
