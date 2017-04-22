if exists("g:loaded_motion_join")
  finish
endif
let g:loaded_motion_join=1

nnoremap J :set operatorfunc=Joinoperator<CR>g@
nnoremap gJ :set operatorfunc=GJoinoperator<CR>g@
onoremap J j
func! Joinoperator(submode)
        '[,']join
endfunc
func! GJoinoperator(submode)
        '[,']join!
endfunc
