"set runtimepath=$HOME/.vim,$VIM/ultisnips,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$VIM/ultisnips/after,$HOME/.vim/after

"if &shell =~# 'fish$'
"  set shell=/bin/sh
"endif
"
set nocompatible

if &shell =~# 'fish$'
  set shell=/bin/sh
endif

runtime plugins.vim
runtime! ftdetect/UltiSnips.vim

set autowrite
set autowriteall
set expandtab
set modeline
set sw=2
set ts=2
set scrolloff=4
set pastetoggle=[23~
set gdefault

"O	message for reading a file overwrites any previous message.
"Also for quickfix message (e.g., ":cn").
"t	truncate file message at the start if it is too long to fit
"T	truncate other messages in the middle if they are too long to
"I	don't give the intro message when starting Vim |:intro|.
"c	don't give |ins-completion-menu| messages.  For example,
"   c really useful for echodoc
set shortmess+=IcOtT
set number
"set relativenumber "more confusing than useful
set cursorline
set noshowmode
set foldlevelstart=2

set title

set wildmode=list:longest

set undodir="~/.vim/undo"
set undofile

set clipboard+=unnamed
set clipboard+=unnamedplus

set t_ut= "Needed to get non-text background colors to work correctly in urxvt + tmux
let s:hour = str2nr(strftime("%H"))
if s:hour > 6 && s:hour < 21
  set background=light
else
  set background=dark
endif

colorscheme solarized
nnoremap <F12> "*p

let g:delimitMate_offByDefault=1 "Just can't stand it anymore
"let g:delimitMate_expand_cr=1
"let g:delimitMate_expand_space=1
"
set tags+=.git/bundle-tags

if exists("$EXTRA_VIM")
  for path in split($EXTRA_VIM, ':')
    exec "source " .path
  endfor
endif

set inccommand=split

" These are all included in vim-sensible
"filetype plugin indent on
"syntax on
"set laststatus=2
"set backspace=2
"set incsearch
"set hlsearch
"set wildmenu
"set encoding=utf-8
