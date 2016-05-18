function __cache_or_get_rake_completion -d "Create rake completions"
  __cache_or_get "rake" 'Rakefile' 'rake -T 2>&1 | sed -e "s/^rake \([a-z:_0-9!\-]*\).*#\(.*\)/\1\t\2/"'
end

function __should_complete_rake
  lookup Rakefile; or lookup rakefile; or lookup Rakefile.rb; or lookup rakefile.rb
end

complete -r -c rake -a "(__cache_or_get_rake_completion)" -n __should_complete_rake
