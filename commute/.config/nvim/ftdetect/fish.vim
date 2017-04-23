autocmd BufRead fish_funced* call search('^$')
autocmd BufRead,BufNewFile fish_funced* setfiletype fish
