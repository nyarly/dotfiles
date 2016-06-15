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
    CompilerSet makeprg=go\ test
endif
" vim:ts=4:sw=4:et
