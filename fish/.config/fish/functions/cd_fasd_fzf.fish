# Defined in /tmp/fish.dOJ1rH/cd_fasd_fzf.fish @ line 2
function cd_fasd_fzf
	cd (fasd -ld | fzf)
  commandline -f repaint
  emit fish_prompt
end
