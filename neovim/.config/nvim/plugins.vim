
function! UpdateRemote(info)
  if a:info.status == 'installed' || a:info.status == 'updated' || a:info.force
    UpdateRemotePlugins
  endif
endfunction

function! InstallGo(info)
  GoInstallBinaries
endfunction

call plug#begin('~/.config/nvim/plugged')

Plug 'sjl/gundo.vim'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'SirVer/ultisnips'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-obsession'
Plug 'mattn/webapi-vim'
Plug 'mattn/gist-vim'
Plug 'IndentAnything'
Plug 'gnupg'
Plug 'timcharper/textile.vim'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-ragtag'
Plug 'othree/html5.vim'
Plug 'seebi/semweb.vim'
Plug 'pangloss/vim-javascript'
Plug 'vim-scripts/rfc-syntax'
Plug 'closetag.vim'
Plug 'dag/vim-fish'
Plug 'LnL7/vim-nix'
Plug 'plasticboy/vim-markdown'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'grensjo/tmuxline.vim'
Plug 'edkolev/promptline.vim'
"tagbar is maybe slow?
Plug 'majutsushi/tagbar'
Plug 'scrooloose/syntastic'
Plug 'godlygeek/tabular'
Plug 'killphi/vim-legend'
Plug 'jeroenbourgois/vim-actionscript'
Plug 'kchmck/vim-coffee-script'
Plug 'chrisbra/Colorizer'
Plug 'vim-scripts/nginx.vim'
Plug 'mxw/vim-jsx'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'rking/ag.vim'
Plug 'fatih/vim-go', { 'do': function('InstallGo') }
Plug 'godoctor/godoctor.vim'
Plug 'Shougo/deoplete.nvim', { 'do': function('UpdateRemote') }
Plug 'zchee/deoplete-go', { 'do': 'make'}
Plug 'Shougo/echodoc.vim'
Plug 'rust-lang/rust.vim', { 'for': ['rust'], 'do': 'cargo install rustfmt \|\| true'}
Plug 'nyarly/jobmake'
Plug 'tomtom/quickfixsigns_vim'
Plug 'vito-c/jq.vim'
Plug 'ekalinin/Dockerfile.vim'
Plug 'critiqjo/lldb.nvim'

call plug#end()
