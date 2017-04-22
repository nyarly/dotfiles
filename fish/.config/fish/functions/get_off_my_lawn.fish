function get_off_my_lawn
	echo I am %self; fuser -ik -9 /proc/(echo %self)/fd/1;
end
