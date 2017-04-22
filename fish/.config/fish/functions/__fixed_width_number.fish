function __fixed_width_number --argument number
	if [ -z $number ];
    set number 0
  end

  if [ $number -lt 1000 ];
    printf "%3d" $number
    return
  end

  set -l exponent (echo "v=(l($number)/l(10)); scale=0; v / 1" | bc -l)
  set -l mantissa (echo "scale=0; $number / 10 ^ $exponent"  | bc -l)

  set -l value {$mantissa}e{$exponent} #XXX add U+23e8 (exponentiation symbol) to monofur
  echo -n $value
end
