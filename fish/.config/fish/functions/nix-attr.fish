function nix-attr
	nix-env -qaP '.*'$argv[1]'.*'
end
