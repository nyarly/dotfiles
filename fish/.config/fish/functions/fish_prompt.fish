# Defined in /tmp/fish.rOIDpO/fish_prompt.fish @ line 2
function fish_prompt
	set -l prompt_bg white

  # colors here are used to match the solarized dynamic-colors scheme

  set_color -b brblue
  set_color $prompt_bg
  echo -n (date '+ %H:%M:%S ')
  set_color -b $prompt_bg
  set_color brblue
  echo -n ⮀
  __fixed_width_number $CMD_SECONDS
  status_glyph
  set_color cyan
  if test (id -u) -eq 0;
    set_color red
  end
  echo -n (whoami)
  echo -n '@'(hostname)' '
  set_color blue
  partial_path
  __fish_git_prompt " "(tput setaf 3)"⭠"(tput setaf 4)" %.20s"
  __git_issue_id__ " [%s]"
  echo -n ' '
  if test -n "$IN_NIX_SHELL"
    set expr (echo $out | sed 's/[^-]*-\([^-]*\).*/\1/')
    if test -z $expr
      echo -n '<nix-shell>'
    else
      echo -n "[$expr]"
    end
  end
  term_reset
  set_color $prompt_bg
  direnv_ps1 ⮀
  term_reset
  echo -n ' '
end
