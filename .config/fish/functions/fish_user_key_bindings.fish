function fish_user_key_bindings
  bind ! bind_bang
  bind '$' bind_dollar
  bind \e\[1~ beginning-of-line
  bind \e\[3~ delete-char
  bind \e\[4~ end-of-line
  bind \e` clobber_history
  bind \es 'prepend_command sudo'
end

if type -q fzf_key_bindings
  fzf_key_bindings
end
