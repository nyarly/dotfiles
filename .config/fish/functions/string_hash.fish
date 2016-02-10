function string_hash --argument string
	echo $string | md5sum --text - | sed 's/\s.*//'
end
