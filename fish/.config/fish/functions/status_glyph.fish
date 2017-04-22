function status_glyph
	switch $LAST_STATUS
  case 0
      term_fcolor 3b1
      echo -n "😉 ";;
  case 1
      term_fcolor c66
      echo -n "😠 ";;
  case 2
      term_fcolor f00
      echo -n "😐 ";;
  case '*'
      term_fcolor f00
      echo -n "😱 ";;
  end
end
