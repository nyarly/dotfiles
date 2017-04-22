function partial_path
	set -l path (pwd)
  set -l string ""
  set -l segcount (echo $path | sed 's#/# #g'|wc -w|sed 's/[[:space:]]//g')
  switch $segcount
  case  0 1 2
    echo -n $path
    return 0
  end
  set -l string (basename {$path})
  set -l path (dirname {$path})
  set -l string (basename {$path})"/$string"
  set -l path (dirname {$path})
  set -l string "…{$segcount}/$string"
  echo -n $string
end
