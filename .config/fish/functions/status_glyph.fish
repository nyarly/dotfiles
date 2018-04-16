# Defined in /run/user/1000/fish.1Jml9Q/status_glyph.fish @ line 2
function status_glyph
	switch $LAST_STATUS
  case 0
      set_color 3b1
      #echo -n "😉 ";;
      echo -n "+ ";;
  case 1
      set_color c66
      #echo -n "😠 ";;
      echo -n "- ";;
  case 2
      set_color f00
      #echo -n "😐 ";;
      echo -n "_ ";;
  case '*'
      set_color f00
      #echo -n "😱 ";;
      echo -n "! ";;
  end
end
