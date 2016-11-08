let g:go_fmt_experimental = 1
"let g:go_fmt_command = "goimports"
let g:syntastic_go_checkers = ['golint', 'govet', 'errcheck']
let g:go_fmt_experimental = 1
"let g:syntastic_mode_map = { 'mode': 'active', 'passive_filetypes': ['go'] }

nnoremap <Leader>I :GoImports<CR>
