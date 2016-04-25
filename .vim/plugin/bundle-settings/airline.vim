let g:airline_powerline_fonts = 1
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

let g:airline_left_sep           = '⮀'
let g:airline_left_alt_sep       = '⮁'
let g:airline_right_sep          = '⮂'
let g:airline_right_alt_sep      = '⮃'
let g:airline_symbols.crypt      = '🔒'
let g:airline_symbols.notexists  = '∄'
let g:airline_symbols.branch     = '⭠'
let g:airline_symbols.readonly   = '⭤'
let g:airline_symbols.linenr     = '⭡'
let g:airline_symbols.paste      = 'ρ'
let g:airline_symbols.whitespace = 'Ξ'

if !exists('g:tmuxline_separators')
  let g:tmuxline_separators = {}
endif


let g:tmuxline_separators.left = g:airline_left_sep
let g:tmuxline_separators.right = g:airline_right_sep
let g:tmuxline_separators.left_alt = g:airline_left_alt_sep
let g:tmuxline_separators.right_alt = g:airline_right_alt_sep

"I think this will clobber hunks if I ever use one of those plugins...
let g:airline_section_b = "%{airline#util#wrap(strpart(airline#extensions#branch#get_head(),0,18),0)}"
let g:airline_extensions = ['branch', 'tabline', 'syntastic', 'tagbar', 'ctrlp', 'tmuxline']
let g:airline#extensions#branch#displayed_head_limit = 18
let g:airline#extensions#branch#format = 2
let g:airline#extensions#branch#format = 2
let g:airline#extensions#tmuxline#snapshot_file = "~/.tmux-statusline-colors.conf"



let g:Powerline_symbols = 'fancy'
let g:Powerline_loaded  = 'not really but I want it disabled'
