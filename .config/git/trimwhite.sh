#!/usr/bin/env sh

export LC_ALL=C
exec sed -e :a -e '/^\\n*$/{$d;N;ba' -e '}' | sed 's/[[:space:]]*$//'
