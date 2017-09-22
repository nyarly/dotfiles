#!/usr/bin/env bash

nc -l -U /tmp/scdaemon.sock | egrep 'PK(SIGN|AUTH)'
#| xargs --delimiter '\n' echo
