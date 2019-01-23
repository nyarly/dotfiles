# Defined in /tmp/fish.PDijWr/cd_fasd_fzf.fish @ line 2
function cd_fasd_fzf
	set path (fasd -ld | fzf --no-sort --tac)
  if test $status -ne 0
    return
  end
  if wmctrl -l | grep -q $path
    set window (begin
      wmctrl -l | grep $path
      echo "Don't"
    end | fzf --prompt "Use existing window?> ")
    if test $status -eq 0; and test $window != "Don't"
      set wname (echo $window | awk '{ print $1 }')
      wmctrl -i -a $wname
      return
    end
  end

  cd $path
  commandline -f repaint
  emit fish_prompt
end
