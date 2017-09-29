#!/bin/sh

source /etc/profile

nc -lU /tmp/scdaemon.sock | while read line; do
  if echo $line | egrep -q 'PK(SIGN|AUTH)'; then
    notify-send "GPG activity" "A process is waiting on the Yubikey!"
  fi
done
