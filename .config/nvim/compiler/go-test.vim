" Copyright 2013 The Go Authors. All rights reserved.
" Use of this source code is governed by a BSD-style
" license that can be found in the LICENSE file.
"
" compiler/go.vim: Vim compiler file for Go.

if exists("current_compiler")
  finish
endif

if !exists("g:gotest_currentpackage")
  let g:gotest_currentpackage = 1
endif

runtime! compiler/go.vim

let current_compiler = "go-test"

function! s:write_wrapped(target)
  call writefile(b:wrapped, a:target)
  call system("chmod +x " . a:target)
endfunction

let b:wrapped=['#!/usr/bin/env bash',
      \"package='./...'",
      \"if [ $# -gt 0 ]; then",
      \'  package="$1"',
      \'fi',
      \"filter='".
      \'/^ok|^\?/ { lines = ""; print; next }; '.
      \'/^FAIL[[:space:]][[:alnum:]]/ { print "BEGIN   " gp "/src/" $2; print lines; print "FAIL    " gp "/src/" $2; lines = ""; next }; '.
      \'{ lines = lines "\n" $0 }'."'",
      \'go test -short "./$package" | awk -v gp=$GOPATH "$filter"',
      \'exit "${PIPESTATUS[0]}"'
      \]

if filereadable(".cadre/test")
  if g:gotest_currentpackage
    CompilerSet makeprg=.cadre/test\ %:h
  else
    CompilerSet makeprg=.cadre/test
  endif
elseif filereadable("makefile") || filereadable("Makefile")
  CompilerSet makeprg=make\ test
else
  call s:write_wrapped("/tmp/go-test.sh")
  if g:gotest_currentpackage
    CompilerSet makeprg=/tmp/go-test.sh\ %:h
  else
    CompilerSet makeprg=/tmp/go-test.sh
  endif
endif

command! -buffer CadreWriteTest call <SID>write_wrapped(".cadre/test")

let s:goerrs=&errorformat

" testing errorformat:
" :set efm=|compiler go-test|cf

CompilerSet errorformat= ""

CompilerSet errorformat+=panic:%m                                           " First line of a panic
CompilerSet errorformat+=%-G%\\s%#/usr/local/Cellar%.%#                     " Panic in go libs
CompilerSet errorformat+=%-G%.%#vendor/%.%#                                 " Hrm. Excluding vendored libs...
CompilerSet errorformat+=%\\s%#%f:%l\ +0x%\\d%#                             " Alternate lines of a panic
"
CompilerSet errorformat+=%-DBEGIN\ \ \ %f
CompilerSet errorformat+=%-XFAIL\ \ \ \ %f
CompilerSet errorformat+=%\\s%#---%\\s%\\+FAIL:%\\s%\\+%m
CompilerSet errorformat+=%Z%\\s%\\+---%\\s%\\+FAIL:%\\s%\\+%m
CompilerSet errorformat+=%E%\\s%#Error\ Trace:%\\s%#%f:%l " Error report
CompilerSet errorformat+=%C%\\s%#Error%\\s%#%m            " Error report

CompilerSet errorformat+=%I%\\d%\\{4%\\}/%\\d%\\{2%\\}/%\\d%\\{2%\\}\ %\\d%\\{2%\\}:%\\d%\\{2%\\}:%\\d%\\{2%\\}\ %f:%l:\ %m                                      " Start of multiline unspecified string is 'filename:linenumber:columnnumber:'
CompilerSet errorformat+=%A%f:%l:%c:\ %m                                      " Start of multiline unspecified string is 'filename:linenumber:columnnumber:'
CompilerSet errorformat+=%A%f:%l:\ %m                                         " Start of multiline unspecified string is 'filename:linenumber:'
CompilerSet errorformat+=%*\\sprevious\ declaration\ at\ %f:%l                " Previous declaration is useful
CompilerSet errorformat+=%C%*\\s%m                                            " Continuation of multiline error message is indented
CompilerSet errorformat+=%Z%\\s%#                         " Blank line ends a testify output
CompilerSet errorformat+=%C%\\s%#%m                           " Error report
""
CompilerSet errorformat+=%-G#\ %.%#                                           " Ignore lines beginning with '#' ('# command-line-arguments' line sometimes appears?)
CompilerSet errorformat+=%Ecan\'t\ load\ package:\ %m                         " Start of multiline error string is 'can\'t load package'
CompilerSet errorformat+=%A%f:%l:%c:\ %m                                      " Start of multiline unspecified string is 'filename:linenumber:columnnumber:'
CompilerSet errorformat+=%A%f:%l:\ %m                                         " Start of multiline unspecified string is 'filename:linenumber:'
CompilerSet errorformat+=%C%*\\s%m                                            " Continuation of multiline error message is indented
CompilerSet errorformat+=%-G%.%#                                              " All lines not matching any of the above patterns are ignored
"
"for s:errf in split(s:goerrs, ",")
"    exec "CompilerSet errorformat+=".escape(s:errf," \"\\\|")
"endfor
unlet s:goerrs

" vim:ts=2:sw=2:et
