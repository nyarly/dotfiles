function rainbowz
  for f in {0..255};
    term_fcolor $f
    echo -n "$f "
  end

  echo
  term_fcolor 0

  for f in {0..255};
    term_bcolor $f
    echo -n "$f "
  end
  echo
end
