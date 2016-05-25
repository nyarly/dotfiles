function update_remote()
  UpdateRemotePlugins
endfunction

call plug#begin('~/.config/nvim/plugged')

Plug 'gmarik/vundle'
Plug 'sjl/gundo.vim'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'SirVer/ultisnips'
Plug 'tpope/vim-fugitive'

Plug 'tpope/vim-obsession'

Plug 'mattn/webapi-vim'
Plug 'mattn/gist-vim'
Plug 'IndentAnything'
Plug 'gnupg'
"Plug 'SimpleFold'
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

Plug 'vim-airline/vim-airline'
Plug 'edkolev/tmuxline.vim'
Plug 'vim-airline/vim-airline-themes'
"
"tagbar is maybe slow?
Plug 'majutsushi/tagbar'

Plug 'scrooloose/syntastic'
Plug 'godlygeek/tabular'

"Plug 'kchmck/vim-coffee-script'
Plug 'killphi/vim-legend'

Plug 'jeroenbourgois/vim-actionscript'
Plug 'kchmck/vim-coffee-script'

Plug 'chrisbra/Colorizer'

Plug 'mxw/vim-jsx'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'rking/ag.vim'

Plug 'fatih/vim-go'
Plug 'godoctor/godoctor.vim'
"Plug 'Shougo/neocomplete'
Plug 'Shougo/deoplete.nvim', { 'do': function('update_remote') }
Plug 'zchee/deoplete-go', { 'do': 'make'}

Plug 'rust-lang/rust.vim'

call plug#end()
