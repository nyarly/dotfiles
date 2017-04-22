export bundle_dir=""
export bundle_bin=""
export orig_path=$PATH

function find_bundle_dir() {
  bundle_dir=$(pwd)
  while [ "$bundle_dir" != "/" ]; do
    if [ -e "$bundle_dir/.bundle/config" ]; then
      return 0
    fi
    bundle_dir=$(dirname "$bundle_dir")
  done
  bundle_dir=""
  export bundle_dir

  return 1
}

function bundle_config_changed() {
  local old_dir=$bundle_dir

  find_bundle_dir

  if [ "$bundle_dir" != "$old_dir" ]; then
    return 0
  else
    return 1
  fi
}


function __bundler_prompt_command(){
  if bundle_config_changed; then
    if [ ! -z "$bundle_bin" ]; then
      export PATH=$(echo $PATH | sed "s!${bundle_bin}\:!!")
    fi
    if [ -e "$bundle_dir/.bundle/config" ]; then
      export bundle_bin=$(readlink -f $(cat "$bundle_dir/.bundle/config" | grep BUNDLE_BIN | awk '{ print $2 }'))
    else
      export bundle_bin=""
    fi
  fi

  if echo $PATH | grep -q -v "$bundle_bin";  then
    export PATH=$bundle_bin:$PATH
  fi
}

function __bundler_ps1(){
  local prompt='B '
  if [ $# -ge 1 ]; then
    prompt=$1
  fi
  if [ ! -z "$bundle_bin" ]; then
    if echo $PATH | grep -q "$bundle_bin"; then
      echo -n $1
    fi
  fi
}
