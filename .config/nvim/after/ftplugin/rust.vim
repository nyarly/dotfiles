let g:deoplete#sources#rust#racer_binary=expand("~/.cargo/bin/racer")
"let g:deoplete#sources#rust#racer_binary="$HOME/.cargo/bin/racer"
let g:deoplete#sources#rust#rust_source_path=glob('/nix/store/*-rust-src')
"let g:deoplete#sources#rust#rust_source_path="/nix/store/ianqn91g4q1j7cb0xqxa2qfwcxmpfgsj-rust-src/"

setlocal tags=./rusty-tags.vi;~/.config/nvim/plugin/rust.tags;/

if get(b:, 'current_compiler', get(g:, 'current_compiler', '')) == ''
  compiler cargo
endif

"function! s:rustyTags()
"  echom getftime(expand('%:p:h')."rusty-tags.vi")
"  let cmd = "rusty-tags vi --start-dir=" . expand('%:p:h')"
"  call jobstart(cmd)
"endfunction
"autocmd BufWrite *.rs :silent call s:rustyTags()
