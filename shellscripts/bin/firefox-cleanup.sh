#!/bin/bash -x
old=$1
new=$2

declare -a files
files=("bookmarks.html" "cookies.sqlite" "cert8.db" "secmod.db" "key3.db"
"signons2.txt" "search.rdf" "search.sqlite" "formhistory.dat")

for f in ${files[@]}; do
  echo $f
  if [ ! -e "$old/$f" ]; then
    echo "File missing from old profile: $old/$f"
    exit 1
  fi
done

for f in ${files[@]}; do
  cp -a "$old/$f" "$new"
done
