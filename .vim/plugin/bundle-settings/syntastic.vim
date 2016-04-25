let g:syntastic_warning_symbol = '→'
let g:syntastic_always_populate_loc_list = 1 "nb: maybe annoying?
let g:syntastic_auto_loc_list = 0
let g:syntastic_loc_list_height = 3
let g:syntastic_ruby_mri_quiet_messages = { "regex": "shadowing outer local variable" }
let g:syntastic_html_tidy_quiet_messages = { "regex": ['<\(lrd-\|xng-\|fa\)[^>]*> is not recognized!', 'discarding unexpected </\?\(lrd-\|xng-\|fa\)[^>]*>', "proprietary attribute \"froala\"", ".*lacks \"alt\" attribute" ]}
let g:syntastic_javascript_jshint_quiet_messages = { "regex": "Regular parameters cannot come after default parameters." }


