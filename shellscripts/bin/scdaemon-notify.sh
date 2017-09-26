#!/usr/bin/env bash

nc -lU /tmp/scdaemon.sock | while read line; do
  if echo $line | egrep -q 'PK(SIGN|AUTH)'; then
    echo "line $line"
  fi
done
