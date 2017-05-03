function __fisher_ignore
	find ~/.config/fish/functions/ -type l | sed "s#"$HOME"##" >> ~/.gitignore.d/fish
	find ~/.config/fish/completions/ -type l | sed "s#"$HOME"##" >> ~/.gitignore.d/fish
end
