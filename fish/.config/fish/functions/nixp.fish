function nixp
	set -l patterns
  for a in $argv
    set patterns $patterns ".*$a.*"
  end
  nix-env -qaP $patterns | fzf -m | awk '{ print $1 }' > /tmp/nixp.result
  and begin
    echo nix-env -iA (cat /tmp/nixp.result)
    nix-env -iA (cat /tmp/nixp.result)
  end
end
