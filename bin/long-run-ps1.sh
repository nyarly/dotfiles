#!/bin/env bash

function __reset_long_run() {
  TTY_NUMBER=$(tty | sed 's!.*/!!')
  TTY_LASTCOMMAND="/tmp/history_age/$TTY_NUMBER"

  rm -f $TTY_LASTCOMMAND
}

#Reduces durations up to 31 years into a 3 character representation
function __fixed_width_number(){
  local number=$1

  if [ $number -lt 1000 ]; then
    printf "%3d" $number
    export LONGRUN="Short $number"
    return
  fi

  local exponent=$(echo "scale=0; l($number)/l(10) - 1" | bc -l)
  local mantissa=$(echo "scale=0; $number / 10 ^ (l($number)/l(10) - 1)"  | bc -l)

  local value="${mantissa}⏨${exponent}"
  export LONGRUN="Long $value"
  echo -n $value
}

function __long_run_ps1() {
  LONG_RUN=60

  mkdir -p /tmp/history_age

  HISTLINE="$*"
  TTY_NUMBER=$(tty | sed 's!.*/!!')
  TTY_LASTCOMMAND="/tmp/history_age/$TTY_NUMBER"

  if [ ! -e "${TTY_LASTCOMMAND}" ]; then
    echo "FIRST ${HISTLINE}" > $TTY_LASTCOMMAND
    echo "-"
    exit 0
  fi

  if grep -q "^FIRST" ${TTY_LASTCOMMAND}; then
    LAST_COMMAND=$(cat ${TTY_LASTCOMMAND} | sed 's/FIRST //')
    if [ "$HISTLINE" = "$LAST_COMMAND" ]; then
      echo "-"
      exit 0
    fi
  fi

  if [ "${HISTLINE}" = "$(<$TTY_LASTCOMMAND)" ]; then
    echo "-"
    exit 0
  fi

  echo $HISTLINE > $TTY_LASTCOMMAND

  COMMAND=$(echo "$HISTLINE" | awk '{ print $3 }')

  TIMESTAMP=$(echo "$HISTLINE" | awk '{ print $2 }')
  SECONDS=$(date +"%s" -d "$TIMESTAMP")
  SECONDS_NOW=$(date +"%s")

  COMMAND_DURATION=$((SECONDS_NOW-SECONDS))

  echo $(__fixed_width_number $COMMAND_DURATION)

  case $COMMAND in
    (man|vim|less|tmux|ssh-tmux|top|watch|git)
      exit 0
      ;;
  esac

  if [ $(which notify-send) -a $COMMAND_DURATION -ge $LONG_RUN ]; then
    notify-send "Long command complete" "The long running command\n  ${HISTLINE}\n has finished.\nTotal duration: ${COMMAND_DURATION}"
  fi

}
