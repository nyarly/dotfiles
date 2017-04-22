#!/usr/bin/env bash

if [ $# -lt 1 ]; then
  echo "Usage: $0 <available config.ext>+"
fi

mrpath=$(dirname $0)
configpath="${mrpath}/config.d/"

mkdir -p "$configpath"

cd "$configpath"

for f in "$@"; do
  name=$(basename "$f")
  availpath="../available.d/${name}"

  if [ -f "$availpath" ]; then
    ln -sf "$availpath" "$name"
  else
    pwd
    echo "Warning: no such file:" ${availpath}
  fi
done
