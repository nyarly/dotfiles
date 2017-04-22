function! s:NonSpecialMappings()
  nnoremap <buffer> <F3> :<C-U>GundoToggle<CR>
  noremap <buffer> <F4> :<C-U>CtrlPBuffer<CR>
  inoremap <buffer> <F4> <Esc>:<C-U>CtrlPBuffer<CR>
  nnoremap <buffer> <silent> <CR> i<CR><Esc>
  nnoremap <buffer> <silent>  <F6> :TagbarToggle<CR>
  nnoremap <buffer> <silent>  <F5> :TagbarOpenAutoClose<CR>
"imap <buffer> <C-L> <Plug>delimitMateJumpMany
  "like . but for commands

  vmap <buffer> <Up> <ESC>'>gvk
  vmap <buffer> <Down> <ESC>'<gvj
  vmap <buffer> <Left> <gv
  vmap <buffer> <Right> >gv
endfunction

function! s:SetMappings()
  if(! exists("b:mappings_set"))
    let b:mappings_set=1
    if &buftype == ''
      call s:NonSpecialMappings()
    endif
  endif
endfunction

function! ToggleDark()
  if &background == "light"
    set background=dark
  else
    set background=light
  endif
  colorscheme solarized
endfunction

function! DoMake()
  make
  cwin
endfunction

"use gQ for Ex mode anyway
map Q gq

tnoremap <A-n> <C-\><C-n><C-w>c
tnoremap <A-x> <C-\><C-n><C-w>c
tnoremap <A-h> <C-\><C-n><C-w>h
tnoremap <A-j> <C-\><C-n><C-w>j
tnoremap <A-k> <C-\><C-n><C-w>k
tnoremap <A-l> <C-\><C-n><C-w>l
nnoremap <A-n> <C-w>c
nnoremap <A-x> <C-w>c
nnoremap <A-h> <C-w>h
nnoremap <A-j> <C-w>j
nnoremap <A-k> <C-w>k
nnoremap <A-l> <C-w>l
nnoremap WW :TrimWhite<CR>:update<CR>
nnoremap <C-w><C-w> <C-w><C-p>
nnoremap <C-w>w <C-w><C-p>
imap <C-W> <Esc>:
imap <C-H> <C-O>h
imap <C-J> <C-O>j
imap <C-K> <C-O>k
noremap <silent><Leader>] <Esc>:nohls<CR>
noremap <silent><Leader>q <Esc>:nohls<CR>
inoremap <Leader>a <Esc>:Ag <C-R><C-W><CR>
nnoremap <Leader>a :Ag <C-R><C-W><CR>
inoremap jk <Esc>
inoremap jK <Esc>
nnoremap MM :Jmake<CR>
nnoremap / /\v
vnoremap / /\v
cmap w!! %!sudo tee > /dev/null %
map <F7> :call ToggleDark()<CR>

autocmd BufReadPost,BufNewFile * call s:SetMappings()
