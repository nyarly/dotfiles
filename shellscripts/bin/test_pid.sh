#!/bin/env bash

echo $BASHPID $$ $BASH_SUBSHELL $SHLVL $(tty)
echo $(history 3)
