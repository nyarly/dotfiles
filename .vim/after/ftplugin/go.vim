NeoCompleteEnable


function! s:SetMarks()
  2mark i
  0/import/mark i
  0/import (/+1mark i
  'i/)/+2mark c
  0/const/mark c
  0/const (/+1mark c
endfunction

silent! call s:SetMarks()

map <Leader>i <C-\><C-n>'iO""<Left>
