if has('vim_starting')
  augroup VWPre
    au VimEnter * source <sfile>|augroup! VWPre
  augroup END

  finish
endif

if exists('loaded_sticky') || !exists('g:vwrole') || &cp
  finish
endif
let loaded_sticky=1

" Sticky buffer name
let StickyBufferName = "__Sticky__"

" StickyBufferOpen
" Open the sticky buffer
function! s:StickyBufferOpen()
  nnoremap ZZ :TrimWhite<CR>:update<CR>

  " Check whether the sticky buffer is already created
  let scr_bufnum = bufnr(g:StickyBufferName)
  if scr_bufnum == -1
    exe "new +call\\ s:StickyMarkBuffer() " . g:StickyBufferName
    exe "wincmd c"
  endif
endfunction

function! s:StickyBufferClose()
  nunmap ZZ
  let scr_bufnum = bufnr(g:StickyBufferName)
  if scr_bufnum != -1
    exe "bwipeout! " . g:StickyBufferName
  endif
endfunction

function! s:StickyWriteBuffer()
  return 0
endfunction

" StickyMarkBuffer
" Mark a buffer as sticky
function! s:StickyMarkBuffer()
  "echom "Marking sticky"
  setlocal bufhidden=hide
  setlocal noswapfile
  setlocal nobuflisted
  setlocal modified
endfunction

function! s:StickyQuit()
  call s:StickyBufferClose()
  wall
  q
endfunction

function! s:PathToRole(path)
  let path = fnamemodify(a:path,':p')
  echom "Finding role for: " . path

  if &buftype == 'nofile' || &filetype == 'snippets'
    let role_is = g:vwrole
  else
    let role_is = substitute(system("vim-role " . path),'\n','','')
    if v:shell_error != 0
      echom "Couldn't find a role - using 'unknown'"
      let role_is = "unknown"
    endif
  endif

  return role_is
endfunction

function! s:FilterFiles()
  let filename = expand('%:t')
  if( match(filename, '^__.*__$') != -1)
    return
  endif
  if( expand('%') == g:StickyBufferName || &buftype != '' || &buftype == 'nofile' || &readonly || !&buflisted || &filetype == 'fugitiveblame' || !exists('g:vwrole') )
    return
  endif

  let path = expand('%:p')
  let path_role = s:PathToRole(path)
  if( g:vwrole != l:path_role )
    echom "Path: ".path
    echom "File doesn't belong in this editor - reopening in [".path_role."]"

    let vw_output = system("vw -r ".path_role." ".path)
    if( v:shell_error == 0 )
      let b:rejected=1
      setlocal noswapfile
      setlocal readonly
    else
      echom "Failure reopening file: ".path
      echom vw_output
    endif
  endif
endfunction

function! s:CloseRejected()
  if( exists("b:rejected"))
    bdelete!
  endif
endfunction

function! s:FilterAllBuffers()
  bufdo! call s:FilterFiles()
  bufdo! call s:CloseRejected()
endfunction

function! s:CleanQuickfix()
  let lines=getqflist()
  let new_lines=[]
  for line in lines
    let buf_file = bufname(line['bufnr'])
    if(line['bufnr'] != 0 && s:PathToRole(buf_file) == g:vwrole)
      call add(new_lines, line)
    endif
  endfor

  call setqflist(new_lines)
endfunction

function! s:SwapExists()
  if( exists("v:swapchoice") && v:swapchoice != '')
    return
  endif

  let path_role = s:PathToRole(expand('<afile>:p'))
  if( g:vwrole != l:path_role )
    let v:swapchoice = 'o'
  else
    let v:swapchoice = ''
  endif
endfunction

if( g:vwrole =~ '^\(test\|app\|views\)$')
  call s:StickyBufferOpen()
endif

exe "autocmd BufReadPre ".g:StickyBufferName." call s:StickyMarkBuffer()"
exe "autocmd BufNewFile ".g:StickyBufferName." call s:StickyMarkBuffer()"
exe "autocmd BufWriteCmd ".g:StickyBufferName." call s:StickyWriteBuffer()"
exe "autocmd BufEnter ".g:StickyBufferName." call s:StickyMarkBuffer()"
exe "autocmd BufLeave ".g:StickyBufferName." call s:StickyMarkBuffer()"

autocmd BufReadPre,BufNewFile,FilterReadPre,FileReadPre * call s:FilterFiles()
autocmd BufReadPost,FilterReadPost,FileReadPost * call s:CloseRejected()
autocmd SwapExists * call s:SwapExists()

" Command to create the sticky buffer in the current window
command! -nargs=0 Sticky call s:StickyBufferOpen()
command! -nargs=0 Unsticky call s:StickyBufferClose()
command! -nargs=0 StickyQuit call s:StickyQuit()
command! -nargs=0 QuitSticky call s:StickyQuit()
command! -nargs=0 CleanQF call s:CleanQuickfix()
command! -nargs=0 LoadQF cget|call s:CleanQuickfix()|cc

call s:FilterAllBuffers()
