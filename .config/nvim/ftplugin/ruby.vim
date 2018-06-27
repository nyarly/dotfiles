setlocal shiftwidth=2
setlocal ts=2
setlocal formatoptions=croqwal
setlocal expandtab
setlocal lazyredraw

let b:surround_{char2nr("d")} = "do \r end"
let b:surround_{char2nr("-")} = "<% \r %>"
let b:surround_{char2nr("=")} = "<%= \r %>"

let ruby_minlines = 150
set nofoldenable
set foldlevel=3

let b:toggle_foldmethod='syntax'

setlocal spell
setlocal spelllang=en_us

function! s:bundlerpath()
  let s:Gemfile = findfile("Gemfile", expand('<afile>:h').';'.$HOME)
  let s:libdir = fnamemodify(s:Gemfile,":h")

  let s:ruby_path_prefix = ".,,lib,app,config/initializer,spec,test,"
  let s:rg_get_paths_code = "require 'rubygems'; (['".s:libdir."'] + Gem::path.map{|path| File::join(path, 'gems/**')}).join(',')"

  let s:b_get_paths_code = "Dir.chdir('".s:libdir."'){ require 'bundler'; ['".s:libdir."', Bundler.bundle_path + 'gems/**'].join(',')}"

  if has("ruby")
    let let_prefix = "ruby VIM::command( 'let g:ruby_path = \"%s\"' % ("
    let let_suffix = "))"
    let b_pathcode = let_prefix . s:b_get_paths_code . let_suffix
    let rg_pathcode = let_prefix . s:rg_get_paths_code . let_suffix
    echom b_pathcode
    try
      exe b_pathcode
    catch
      echom "Bundler error, falling back to rubygems for path"
      echom v:exception
      echom "Getting path from rubygems instead:"
      echom rg_pathcode
      exe rg_pathcode
    endtry

    echom "Ruby path is now:"
    echom g:ruby_path
    let g:ruby_path = s:ruby_path_prefix . substitute(g:ruby_path, '\%(^\|,\)\.\%(,\|$\)', ',,', '')
    echom "Ruby path cleaned to:"
    echom g:ruby_path
  elseif executable("ruby")
    function s:run_exe_ruby(code)
      if &shellxquote == "'"
        let g:ruby_path = system('ruby -e "print ' . a:code . '"')
      else
        let g:ruby_path = system("ruby -e 'print " . a:code . "'")
      endif
    endfunction

    exe s:run_exe_ruby(s:b_get_paths_code)
    if v:shell_error
      exe s:run_exe_ruby(s:rg_get_paths_code)
    endif
    let g:ruby_path = s:ruby_path_prefix . substitute(g:ruby_path, '\%(^\|,\)\.\%(,\|$\)', ',,', '')
  else
    " If we can't call ruby to get its path, just default to using the
    " current directory and the directory of the current file.
    let g:ruby_path = s:ruby_path_prefix
  endif
endfunction

silent call s:bundlerpath()
"call s:bundlerpath()
