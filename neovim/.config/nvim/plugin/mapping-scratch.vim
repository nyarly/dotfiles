
function! s:MappingsScratch()
  new
  setlocal buftype=nofile
  setlocal bufhidden=hide
  setlocal noswapfile
  put =execute('map')
endfunction

command Map call <SID>MappingsScratch()
