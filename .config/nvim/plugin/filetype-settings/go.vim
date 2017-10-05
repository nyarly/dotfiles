let g:go_fmt_experimental = 1
"let g:go_fmt_command = "goimports"
let g:syntastic_go_checkers = ['golint', 'govet', 'errcheck']
"let g:syntastic_mode_map = { 'mode': 'active', 'passive_filetypes': ['go'] }
let g:go_fmt_experimental = 1
" otherwise vim-go closes splits
let g:go_list_type = "locationlist"

nnoremap <Leader>I :GoImports<CR>

set wildignore+=*/vendor/*
