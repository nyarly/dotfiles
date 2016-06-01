function fish_prompt
	set -l prompt_bg e0e0e0
  switch (hostname)
  case "dijkstra"
    set -l prompt_bg e0e0e0
  case  *
    set -l prompt_bg eef
  end


  term_bcolor 999
  term_fcolor $prompt_bg
  echo -n (date '+ %H:%M:%S ')
  term_bcolor $prompt_bg
  term_fcolor 999
  echo -n ⮀
  __fixed_width_number $CMD_SECONDS
  status_glyph
  term_fcolor 3b1
  if test (id -u) -eq 0;
    term_fcolor fbb
  end
  echo -n (whoami)
  term_fcolor 3b1
  echo -n '@'(hostname)' '
  term_fcolor 0bb
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
  term_fcolor $prompt_bg
  direnv_ps1 ⮀
  term_reset
  echo -n ' '
end
