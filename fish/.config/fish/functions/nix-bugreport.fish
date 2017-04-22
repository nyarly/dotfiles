function nix-bugreport
	set -l report "* System: "(nixos-version)
  set report $report \n"* Nix version: "(nix-env --version)
  set report $report \n"* Nixpkgs version: "(nix-instantiate --eval '<nixpkgs>' -A lib.nixpkgsVersion)
  echo "Copied to clipboard:"
  echo $report
  echo $report | xsel
end
