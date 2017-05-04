function __fisher_ignore
	comm -13 (sort ~/.gitignore.d/fish | psub) (find ~/.config/fish/functions/ -type l | sed "s#"$HOME"##"|sort |psub) >> ~/.gitignore.d/fish
	comm -13 (sort ~/.gitignore.d/fish | psub) (find ~/.config/fish/completions/ -type l | sed "s#"$HOME"##"|sort |psub) >> ~/.gitignore.d/fish
end
