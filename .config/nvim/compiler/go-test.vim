" Copyright 2013 The Go Authors. All rights reserved.
" Use of this source code is governed by a BSD-style
" license that can be found in the LICENSE file.
"
" compiler/go.vim: Vim compiler file for Go.

if exists("current_compiler")
  finish
endif

runtime! compiler/go.vim

let current_compiler = "go-test"

if filereadable("makefile") || filereadable("Makefile")
    CompilerSet makeprg=make\ test
else
    CompilerSet makeprg=go\ test\ -short\ ./...
endif

let s:goerrs=&errorformat


CompilerSet errorformat= ""
"CompilerSet errorformat+= ""
"
CompilerSet errorformat=%E---\ FAIL:\ %m
CompilerSet errorformat+=%C%\\s%#%\\S%#%[\	\ ]%#Error\ Trace:%\\s%#%f:%l "Error report
CompilerSet errorformat+=%C%\\s%#%\\S%#%[\	\ ]%#Error%\\s%#%m "Error report
CompilerSet errorformat+=%C%\\s%#%\\S%#%[\	\ ]%# "Error report
CompilerSet errorformat+=%C%\\s%#%\\S%#%[\	\ ]%#%m "Error report
CompilerSet errorformat+=%ZFAIL
"
CompilerSet errorformat+=%-G#\ %.%#                   " Ignore lines beginning with '#' ('# command-line-arguments' line sometimes appears?)
CompilerSet errorformat+=%Ecan\'t\ load\ package:\ %m " Start of multiline error string is 'can\'t load package'
CompilerSet errorformat+=%A%f:%l:%c:\ %m              " Start of multiline unspecified string is 'filename:linenumber:columnnumber:'
CompilerSet errorformat+=%A%f:%l:\ %m                 " Start of multiline unspecified string is 'filename:linenumber:'
CompilerSet errorformat+=%C%*\\s%m                    " Continuation of multiline error message is indented
CompilerSet errorformat+=%-G%.%#                      " All lines not matching any of the above patterns are ignored

"for s:errf in split(s:goerrs, ",")
"    exec "CompilerSet errorformat+=".escape(s:errf," \"\\\|")
"endfor
unlet s:goerrs

"--- FAIL: TestRoundTrip (0.00s)
"	assertions.go:225:                         	Error Trace:	image_mapping_test.go:61
"			Error:		Not equal: "docker.repo.io/wackadoo@sha256:deadbeef1234567890" (expected)
"			        != "docker.repo.io/wackadoo:version-1.2.3" (actual)
"		
"FAIL


" vim:ts=4:sw=4:et
