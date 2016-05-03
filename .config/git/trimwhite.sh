#!/usr/bin/env sh

export LC_ALL=C
sed -e :a -e '/^\\n*$/{$d;N;ba' -e '}' | sed 's/[[:space:]]*$//'
