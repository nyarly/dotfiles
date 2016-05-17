if &shell =~# 'fish$'
  set shell=sh
endif

set nocompatible
filetype off

"Future reference: git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/vundle
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Bundle 'gmarik/vundle'
Bundle 'sjl/gundo.vim'
Bundle 'kien/ctrlp.vim'
Bundle 'SirVer/ultisnips'
Bundle 'tpope/vim-fugitive'

Bundle 'tpope/vim-obsession'

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

Bundle 'othree/html5.vim'
Bundle 'seebi/semweb.vim'
Bundle "pangloss/vim-javascript"
Bundle "vim-scripts/rfc-syntax"
Bundle "closetag.vim"
Bundle "dag/vim-fish"
Bundle "LnL7/vim-nix"

Bundle 'vim-airline/vim-airline'
Bundle 'edkolev/tmuxline.vim'
Bundle 'vim-airline/vim-airline-themes'
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
Bundle 'godoctor/godoctor.vim'
Bundle 'Shougo/neocomplete'

Bundle 'rust-lang/rust.vim'

filetype plugin indent on
