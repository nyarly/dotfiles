function fasd_cd
	if [ (count $argv) -le 1 ]
fasd $argv
else
set -l _fasd_ret (fasd -e 'printf %s' $argv)
if [ -z $_fasd_ret ]
return
end
if [ -d $_fasd_ret ]
cd "$_fasd_ret"; or printf %s\n $_fasd_ret
end
end
end
