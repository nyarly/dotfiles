function! s:insert_unreleased()
  let l:version = system('git tag | grep "[.].*[.]" | versiontool sort | tail -n 1')
  if v:shell_error != 0
    echom "versiontool returned error: " . l:version
    return
  endif
  let l:version = substitute(l:version, "\n", "", "")
  let l:repopattern = '^## \[[^]]*\](\/\/\(github.com\/.*\)\/compare.*'
  let l:repo = substitute(getline(search(l:repopattern, "nW")), l:repopattern, '\1', "")
  call append(line("."), "## [Unreleased](//".l:repo. "/compare/". l:version ."...HEAD)")
endfunction

command! -buffer Unreleased call <SID>insert_unreleased()
