# Defined in /tmp/fish.PDijWr/cd_fasd_fzf.fish @ line 2
function cd_fasd_fzf
	set path (fasd -ld | fzf --no-sort --tac)
  if test $status -ne 0
    return
  end
  cd $path
  commandline -f repaint
  emit fish_prompt
end
