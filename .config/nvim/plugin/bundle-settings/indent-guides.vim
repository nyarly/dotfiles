let g:indent_guides_start_level = 5
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_auto_colors = 0
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=#839496 ctermbg=253
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=#93a1a1  ctermbg=254
