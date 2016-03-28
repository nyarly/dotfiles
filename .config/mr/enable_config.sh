#!/usr/bin/env bash

if [ $# -lt 1 ]; then
  echo "Usage: $0 <available config.ext>+"
fi

mrpath=$(dirname $0)
configpath="${mrpath}/config.d/"

mkdir "$configpath"

for f in "$*"; do
  cp "${f}" "$configpath"
done
