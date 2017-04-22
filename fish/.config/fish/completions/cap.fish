function __cache_or_get_cap_completion -d "Create cap completions"
  __cache_or_get "cap" 'cap -T 2>&1 | grep "^cap" |cut -d " " -f 2'
end

complete -x -c cap -a "(__cache_or_get_cap_completion)" -n 'lookup Capfile'
