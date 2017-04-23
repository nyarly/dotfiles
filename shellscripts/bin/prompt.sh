LONG_RUN=30

if [ "$COLORTERM" == "gnome-terminal" ]; then
  if [ -z $TMUX ]; then
    export TERM="xterm-256color"
  else
    export TERM="screen-256color"
  fi
fi

export HISTTIMEFORMAT="%FT%T "
rm -f "/var/run/history_age/$(tty | sed 's!.*/!!')"
export orig_path=$PATH

function reset_long_run() {
  TTY_NUMBER=$(tty | sed 's!.*/!!')
  TTY_LASTCOMMAND="/tmp/history_age/$TTY_NUMBER"

  rm -f $TTY_LASTCOMMAND
}

#Reduces durations up to 31 years into a 3 character representation
function fixed_width_number(){
  local number=$1

  if [ -z $number ]; then
    number=0
  fi

  if [ $number -lt 1000 ]; then
    printf "%3d" $number
    export LONGRUN="Short $number"
    return
  fi

  local exponent=$(echo "scale=0; $(echo "(l($number)/l(10))" | bc -l) / 1" | bc)
  local mantissa=$(echo "scale=0; $number / 10 ^ $exponent"  | bc -l)

  local value="${mantissa}⏨${exponent}"
  export LONGRUN="Long $value"
  echo -n $value
}

function calculate_run_time() {
  mkdir -p /tmp/history_age

  HISTLINE=$(history | tail -n 1 )
  TTY_NUMBER=$(tty | sed 's!.*/!!')
  TTY_LASTCOMMAND="/tmp/history_age/$TTY_NUMBER"

  #No command history yet for this terminal
  if [ ! -e "${TTY_LASTCOMMAND}" ]; then
    echo "FIRST ${HISTLINE}" > $TTY_LASTCOMMAND
    export COMMAND_DURATION=0
    return 0
  fi

  if grep -q "^FIRST" ${TTY_LASTCOMMAND}; then
    LAST_COMMAND=$(cat ${TTY_LASTCOMMAND} | sed 's/FIRST //')
    if [ "$HISTLINE" = "$LAST_COMMAND" ]; then
      export COMMAND_DURATION=0
      return 0
    fi
  fi

  #No command added to history - blank line entered
  if [ "${HISTLINE}" = "$(<$TTY_LASTCOMMAND)" ]; then
    export COMMAND_DURATION=0
    return 0
  fi

  echo $HISTLINE > $TTY_LASTCOMMAND

  COMMAND=$(echo "$HISTLINE" | awk '{ print $3 }')
  COMMAND_LINE=$(echo "$HISTLINE" | cut -d " " -f3-)

  TIMESTAMP=$(echo "$HISTLINE" | awk '{ print $2 }')
  SECONDS=$(date +"%s" -d "$TIMESTAMP")
  SECONDS_NOW=$(date +"%s")

  export COMMAND_DURATION=$((SECONDS_NOW-SECONDS))

  case $COMMAND in
    (man|vim|less|tmux|ssh-tmux|top|watch|git)
      return 0
      ;;
  esac

  if [ $(which notify-send) -a $COMMAND_DURATION -ge $LONG_RUN ]; then
    notify-send "Long command complete" "The long running command\n  ${COMMAND_LINE}\n has finished.\nTotal duration: ${COMMAND_DURATION}"
  fi

}

function partial_path(){
  local path=$(pwd)
  local string=""
  case $(echo $path | sed 's#/# #g'|wc -w) in
    (0|1|2) echo -n $path; return 0;;
esac
  string="$(basename "${path}")"
  path=$(dirname "${path}")
  string="$(basename "${path}")/${string}"
  path=$(dirname "${path}")
  string="…$(echo $path | sed 's#/# #g'|wc -w)/${string}"
  echo -n $string
}

function collect_last_status(){
  export LAST_COMMAND_STATUS=$?
}

function prompt_commands(){
  #bundler_prompt_command
  calculate_run_time
  set_ps1
}

export PROMPT_DIRTRIM=2
if [[ ! $PROMPT_COMMAND =~ prompt_commands ]]; then
  export PROMPT_COMMAND="prompt_commands ; ${PROMPT_COMMAND:-:}"
fi

reset_long_run

#TODO: Consider using a) a PROMPT_COMMAND fuction for all this
#Consider using tput for setting colors etc (better functionality than ANSI escapes?)

function term_fcolor() {
  echo -n "\[$(tput setaf $1)\]"
}

function term_bcolor() {
  echo -n "\[$(tput setab $1)\]"
}

function term_reset() {
  echo -n "\[$(tput sgr0)\]"
}

function direnv_ps1(){
  local prompt='d '
  if [ $# -ge 1 ]; then
    prompt=$1
  fi
  if [ ! -z $DIRENV_DIR ]; then
    case $DIRENV_LAYOUT in
      c) term_fcolor 10;;
      shell) term_fcolor 57;;
      ruby) term_fcolor 124;;
      go) term_fcolor 94;;
      node) term_fcolor 202;;
      javascript) term_fcolor 202;;
      python) term_fcolor 68;;
      java) term_fcolor 166;;
      erlang) term_fcolor 36;;
      vim) term_fcolor 28;;
      *) term_fcolor 250;;
    esac
  fi
  echo -n $prompt
}

function status_glyph(){
  case $LAST_COMMAND_STATUS in
    0)
      term_fcolor 70
      echo -n "😉 ";;
    1)
      term_fcolor 202
      echo -n "😠 ";;
    2)
      term_fcolor 196
      echo -n "😐 ";;
    *)
      term_fcolor 196
      echo -n "😱 ";;
  esac
}

tput sgr0

function show_terminal_colors(){
  echo $(
    for f in {0..255}; do
      tput setaf $f
      echo -n "$f "
    done

    echo
    tput setaf 0

    for f in {0..255}; do
      tput setab $f
      echo -n "$f "
    done
    tput sgr0
  )
}

function set_ps1(){
  local prompt_bg=157
  case $(hostname) in
    "dijkstra")
      prompt_bg=254
      ;;
    *)
      prompt_bg=229
      ;;
  esac

  #Use term-colors to review actual color codes
  # Put your fun stuff here.
  #for f in {0..255}; do
  #  term_fcolor $f
  #  PS1+="$f "
  #done
  #
  #PS1+="\n"
  #term_fcolor 0
  #
  #for f in {0..255}; do
  #  term_bcolor $f
  #  PS1+="$f "
  #done
  #PS1+="\n"

  PS1="$(
    term_bcolor $prompt_bg
    term_fcolor 244
    fixed_width_number $COMMAND_DURATION
    status_glyph
    term_fcolor 54
    if [ $(id -u) -eq 0 ]; then
     term_fcolor 160
    else
      term_fcolor 70
    fi
    echo -n '\u'
    term_fcolor 70
    echo -n '@\h '
    term_fcolor 54
    term_fcolor 27
    partial_path
    __git_ps1 " \[$(tput setaf 3)\]⭠\[$(tput setaf 4)\] %.20s"
    echo -n ' '
    term_reset
    term_fcolor $prompt_bg
    direnv_ps1 ⮀
    term_reset
    echo -n ' '
  )"
}

export GIT_PS1_SHOWUNTRACKEDFILES=yes
export GIT_PS1_SHOWDIRTYSTATE=yes
