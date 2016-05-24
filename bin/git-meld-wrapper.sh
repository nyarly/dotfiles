#!/bin/env bash

#path old-file old-hex old-mode new-file new-hex new-mode
path=$1
old=$2
new=$5

#Per git(1):
#The file parameters can point at the user’s working file (e.g.  new-file in "git-diff-files"), /dev/null (e.g.
#old-file when a new file is added), or a temporary file (e.g.  old-file in the index).  GIT_EXTERNAL_DIFF should
#not worry about unlinking the temporary file --- it is removed when GIT_EXTERNAL_DIFF exits.

#For a path that is unmerged, GIT_EXTERNAL_DIFF is called with 1 parameter, <path>.


meld $2 $5
