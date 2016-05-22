if exists('loaded_rolequickfix') || &cp
  finish
endif
let loaded_rolequickfix=1

fun! s:BuildQFList()
  if(!exists('g:vwrole'))
    cget &errorfile
    return
  endif

  cgetexpr system('vim-errfile-taxo-filter'.' '. g:vwrole . ' ' . &errorfile)
endf

fun! s:QFForRole()
  call s:BuildQFList()
  cwindow
  if len(getqflist()) > 0
    update
    cc!
  endif
endfun

command! -nargs=0 QuickfixRole call s:QFForRole()
