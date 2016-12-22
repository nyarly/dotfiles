if get(b:, 'current_compiler', get(g:, 'current_compiler', '')) == ''
  compiler cargo
endif

setlocal tags=./rusty-tags.vi;/
autocmd BufWrite *.rs :silent exec "!rusty-tags vi --start-dir=" . expand('%:p:h') . "&"
