function nix-current-ld
	cat (nix-store --query --outputs (nix-instantiate "<nixpkgs>" -A gcc ^/dev/null) | grep -v debug)/nix-support/dynamic-linker
end
