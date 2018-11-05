# Defined in /tmp/fish.guEfZx/rainbowz.fish @ line 2
function rainbowz
	set -l color_names black red green yellow blue magenta cyan white brblack brred brgreen bryellow brblue brmagenta brcyan brwhite
	for f in $color_names;
    term_fcolor $f
    echo -n "$f "
  end

  echo
  term_fcolor 0

  for f in $color_names;
    term_bcolor $f
    echo -n "$f "
  end
  echo
end
