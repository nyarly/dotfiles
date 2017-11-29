# Defined in /run/user/1000/fish.rsbfmt/cd_fasd_fzf.fish @ line 1
function cd_fasd_fzf
	cd (fasd -l | fzf)
end
