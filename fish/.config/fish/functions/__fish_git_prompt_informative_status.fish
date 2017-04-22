function __fish_git_prompt_informative_status
	set -l changedFiles
  set -l stagedFiles
  set -l untrackedfiles

  if type -q timeout
    set changedFiles (timeout 0.5 git diff --name-status | cut -c 1-2; or echo 0)
    set stagedFiles (timeout 0.5 git diff --staged --name-status | cut -c 1-2; or echo 0)
    set untrackedfiles (count (timeout 0.5 git ls-files --others --exclude-standard; or echo))
  else
    set changedFiles (git diff --name-status | cut -c 1-2; or echo 0)
    set stagedFiles (git diff --staged --name-status | cut -c 1-2; or echo 0)
    set untrackedfiles (count (git ls-files --others --exclude-standard; or echo))
  end

  set -l dirtystate (math (count $changedFiles) - (count (echo $changedFiles | grep "U")))
  set -l invalidstate (count (echo $stagedFiles | grep "U"))
  set -l stagedstate (math (count $stagedFiles) - $invalidstate)

  set -l info

  if [ (math $dirtystate + $invalidstate + $stagedstate + $untrackedfiles) = 0 ]
    set info $___fish_git_prompt_color_cleanstate$___fish_git_prompt_char_cleanstate$___fish_git_prompt_color_cleanstate_done
  else
    for i in $___fish_git_prompt_status_order
      if [ $$i != "0" ]
        set -l color_var ___fish_git_prompt_color_$i
        set -l color_done_var ___fish_git_prompt_color_{$i}_done
        set -l symbol_var ___fish_git_prompt_char_$i

        set -l color $$color_var
        set -l color_done $$color_done_var
        set -l symbol $$symbol_var

        set -l count

        if not set -q __fish_git_prompt_hide_$i
          set count $$i
                          end

                          set info "$info$color$symbol$count$color_done"
                  end
          end
  end
  echo $info
end
