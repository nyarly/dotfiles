let g:go_fmt_experimental = 1
"let g:go_fmt_command = "goimports"
let g:syntastic_go_checkers = ['golint', 'govet', 'errcheck']
"let g:syntastic_mode_map = { 'mode': 'active', 'passive_filetypes': ['go'] }
let g:go_fmt_experimental = 1
" otherwise vim-go closes splits
let g:go_list_type = "locationlist"
let g:go_auto_sameids = 1

set updatetime=100

nnoremap <Leader>I :GoImports<CR>

set wildignore+=*/vendor/*

augroup GoLegend
  au!
  au FileType go LegendEnable
  au BufWinEnter,BufEnter *.go  LegendEnable
augroup END
