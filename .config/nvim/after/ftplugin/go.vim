function! s:SetMarks()
  2mark i
  0/import/mark i
  0/import (/+1mark i
  'i/)/+2mark c
  0/const/mark c
  0/const (/+1mark c
  'i/)/+2mark t
  0/type/mark t
  0/type (/+1mark t
endfunction

silent! call s:SetMarks()

compiler! go-test

map <Leader>i <C-\><C-n>'iO""<Left>

set keywordprg=devdocs\ go
