let g:ctrlp_custom_ignore = { 'dir':
      \ '/build/test-es6$\|/build/src-es6$\|/pkg$\|/gh-pages$\|/yardoc$\|'.
      \'/doc/coverage$\|/corundum/docs$\|/node_modules$\|'.
      \'/bower_components$\|/ebin$\|/vendor$' }
let g:ctrlp_switch_buffer = 'ETVH'
let g:ctrlp_root_markers = ['.ctrlp-root', '.envrc', '.vim-role', '.git',
      \'.hg', '.svn','.bzr','_darcs']
let g:ctrlp_open_new_file = 'v'
let g:ctrlp_open_multiple_files = '5ij'
let g:ctrlp_arg_map = 1
let g:ctrlp_extensions = ['tag', 'quickfix', 'line']

if executable('rg')
  set grepprg=rg\ --color=never
  let g:ctrlp_user_command = 'rg %s --files --color=never --glob ""'
  let g:ctrlp_use_caching = 0
endif

set wildignore+=*/.git/*,*/tmp/*,*.swp
