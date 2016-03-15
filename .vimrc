"set runtimepath=$HOME/.vim,$VIM/ultisnips,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$VIM/ultisnips/after,$HOME/.vim/after

if &shell =~# 'fish$'
  set shell=sh
endif

set nocompatible
filetype off

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Bundle 'gmarik/vundle'
Bundle 'nyarly/gundo'
Bundle 'kien/ctrlp.vim'
Bundle 'SirVer/ultisnips'
Bundle 'tpope/vim-fugitive'

"Bundle 'rking/vim-ruby-refactoring'

Bundle 'mattn/webapi-vim'
Bundle 'mattn/gist-vim'
Bundle 'IndentAnything'
Bundle 'gnupg'
"Bundle 'SimpleFold'
Bundle 'timcharper/textile.vim'
Bundle 'tpope/vim-unimpaired'
Bundle 'tpope/vim-endwise'
Bundle 'tpope/vim-surround'
Bundle 'tpope/vim-abolish'
Bundle 'tpope/vim-ragtag'

Bundle 'seebi/semweb.vim'
Bundle "pangloss/vim-javascript"
Bundle "vim-scripts/rfc-syntax"
Bundle "closetag.vim"
Bundle "dag/vim-fish"
Bundle "LnL7/vim-nix"

"fonts weren't immediately working..
Bundle 'bling/vim-airline'
"Bundle 'bling/vim-bufferline'
"
"tagbar is maybe slow?
Bundle 'majutsushi/tagbar'

Bundle 'scrooloose/syntastic'
Bundle 'godlygeek/tabular'

"Bundle 'kchmck/vim-coffee-script'
Bundle 'killphi/vim-legend'

Bundle "jeroenbourgois/vim-actionscript"
Bundle "kchmck/vim-coffee-script"

Bundle "chrisbra/Colorizer"

Bundle 'mxw/vim-jsx'
Bundle 'nathanaelkane/vim-indent-guides'
Bundle 'rking/ag.vim'

Bundle 'fatih/vim-go'

runtime! ftdetect/UltiSnips.vim
filetype plugin indent on
set laststatus=2
set incsearch
set expandtab
set modeline
set sw=2
set pastetoggle=[23~
set gdefault
set shortmess+=I
set cursorline
set scrolloff=4

nnoremap <F12> "*p

let javaScript_fold = 1
let ruby_minlines = 150
let ruby_operators = 'yes'

let g:airline_powerline_fonts = 1
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

let g:airline_left_sep                   = '⮀'
let g:airline_left_alt_sep               = '⮁'
let g:airline_right_sep                  = '⮂'
let g:airline_right_alt_sep              = '⮃'
let g:airline_symbols.branch             = '⭠'
let g:airline_symbols.readonly           = '⭤'
let g:airline_symbols.linenr             = '⭡'
let g:airline_symbols.paste              = 'ρ'
let g:airline_symbols.whitespace         = 'Ξ'
"I think this will clobber hunks if I ever use one of those plugins...
let g:airline_section_b = "%{airline#util#wrap(strpart(airline#extensions#branch#get_head(),0,18),0)}"

let g:Powerline_symbols = 'fancy'
let g:Powerline_loaded  = 'not really but I want it disabled'
set encoding=utf-8

let g:GPGPreferArmor = 1
let g:GPGPreferSign = 1
let g:GPGUsePipes = 1
let g:GPGDefaultRecipients = [ 'judson@lrdesign.com' ]

let g:syntastic_error_symbol = '✗'
let g:syntastic_warning_symbol = '→'
let g:syntastic_always_populate_loc_list = 1 "nb: maybe annoying?
let g:syntastic_auto_loc_list = 0
let g:syntastic_loc_list_height = 3
let g:syntastic_ruby_mri_quiet_messages = { "regex": "shadowing outer local variable" }
let g:syntastic_html_tidy_quiet_messages = { "regex": ['<\(lrd-\|xng-\|fa\)[^>]*> is not recognized!', 'discarding unexpected </\?\(lrd-\|xng-\|fa\)[^>]*>', "proprietary attribute \"froala\"", ".*lacks \"alt\" attribute" ]}
let g:syntastic_javascript_jshint_quiet_messages = { "regex": "Regular parameters cannot come after default parameters." }

let g:yankring_replace_n_pkey = "<C-Q>"

let g:indent_guides_start_level = 5
let g:indent_guides_enable_on_vim_startup = 1

let g:go_fmt_command = "goimports"

set title

set wildmenu
set wildmode=list:longest

set undodir="~/.vim/undo"
set undofile

set t_ut= "Needed to get non-text background colors to work correctly in urxvt + tmux
let s:hour = str2nr(strftime("%H"))
if s:hour > 6 && s:hour < 21
  set background=light
else
  set background=dark
endif

colorscheme solarized

autocmd BufNewFile,BufFilePre,BufRead *.md set filetype=markdown

let g:snips_author = "Judson Lester"
let g:my_email_addr = "nyarly@gmail.com"
let g:UltiSnipsListSnippets = "<s-tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
let g:UltiSnipsEditSplit="horizontal"

let g:legend_chatty = 1

let g:delimitMate_offByDefault=1 "Just can't stand it anymore
"let g:delimitMate_expand_cr=1
"let g:delimitMate_expand_space=1
"
let g:ctrlp_custom_ignore = { 'dir': '/build/test-es6$\|/build/src-es6$\|/pkg$\|/gh-pages$\|/yardoc$\|/doc/coverage$\|/corundum/docs$\|/node_modules$\|/bower_components$\|/ebin$' }
let g:ctrlp_switch_buffer = 'ETVH'
let g:ctrlp_root_markers = ['.ctrlp-root', '.envrc', '.vim-role']
let g:ctrlp_open_new_file = 'v'
let g:ctrlp_open_multiple_files = '5ij'
let g:ctrlp_arg_map = 1
let g:ctrlp_extensions = ['tag', 'quickfix']

set tags+=.git/bundle-tags

if exists("$EXTRA_VIM")
  for path in split($EXTRA_VIM, ':')
    exec "source " .path
  endfor
endif
