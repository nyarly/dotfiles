let g:ale_open_list = "on_save"
let g:ale_sign_column_always = 1
let g:ale_echo_delay = 90
let g:ale_lint_on_text_changed = "never"
let g:ale_lint_on_insert_leave = 1
let g:ale_linters = { 'ruby': 'all' }
let g:ale_fixers = { 'ruby': 'rubocop' }


let g:ale_go_gobuild_options = "-tags 'integration smoke'"
