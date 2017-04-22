function fzf_key_bindings
	# Due to a bug of fish, we cannot use command substitution,
  # so we use temporary file instead
  if [ -z "$TMPDIR" ]
    set -g TMPDIR /tmp
  end

  function __fzf_escape
    while read item
      echo -n (echo -n "$item" | sed -E 's/([ "$~'\''([{<>})])/\\\\\\1/g')' '
    end
  end

  function __fzf_result_path
    echo $TMPDIR"/fzf_result."(random)".txt"
  end

  function __fzf_fragment_query
    set -l fragment (commandline -t)
    if [ -n $fragment ]
      echo "-q $fragment"
    else
      echo ""
    end
  end

  set -g FZF_IGNORE "Library" "Applications" "vendor" ".node_modules"

  function __fzf_ignore_dir -a dir
    echo "\\( -type d -name '$dir' -prune \\)"
  end

  function __fzf_find_ignore
    if [ (count $FZF_IGNORE) -eq 0 ]
      return
    end
    set -l find_ignore ""

    if [ (count $FZF_IGNORE) -gt 1 ]
      for i in $FZF_IGNORE[1..-2]
        set find_ignore "$find_ignore "(__fzf_ignore_dir $i)" -o "
      end
    end
    set find_ignore "$find_ignore "(__fzf_ignore_dir $FZF_IGNORE[-1])
    echo $find_ignore
  end

  function __fzf_insert_child_file
    __fzf_insert_fuzzy_filename (__fzf_find_command .)" | cut -b3-"
  end

  function __fzf_insert_any_file
    __fzf_insert_fuzzy_filename (__fzf_find_command $HOME)" | cut -b1-"
  end

  function __fzf_find_command -a root_path
    echo "command find -L $root_path \\( -path '*/\\.*' -o -fstype 'dev' -o -fstype 'proc' \\) -prune \
      "(__fzf_find_ignore)" \
      -o -type f -print \
      -o -type d -print \
      -o -type l -print 2> /dev/null | sed 1d"
  end

  function __fzf_insert_fuzzy_filename -a find_command
    echo $find_command
    set -l resultfile (__fzf_result_path)
    eval "$find_command | "(__fzfcmd)" -m "(__fzf_fragment_query)" > $resultfile"
    and sleep 0
    and commandline -i (cat $resultfile | __fzf_escape)
    commandline -f repaint
    rm -f $resultfile
  end

  function __fzf_fuzzy_history_search
    set -l resultfile (__fzf_result_path)
    history | eval (__fzfcmd) +s +m --tiebreak=index --toggle-sort=ctrl-r "(__fzf_fragment_query)" > $resultfile
    and commandline (cat $resultfile)
    commandline -f repaint
    rm -f $resultfile
  end

  function __fzf_fuzzy_chdir
    set -l resultfile (__fzf_result_path)
    set -q FZF_ALT_C_COMMAND; or set -l FZF_ALT_C_COMMAND "
    command find -L . \\( -path '*/\\.*' -o -fstype 'dev' -o -fstype 'proc' \\) -prune \
      -o -type d -print 2> /dev/null | sed 1d | cut -b3-"
    # Fish hangs if the command before pipe redirects (2> /dev/null)
    eval "$FZF_ALT_C_COMMAND | "(__fzfcmd)" +m "(__fzf_fragment_query)"> $resultfile"
    [ (cat $TMPDIR/fzf.result | wc -l) -gt 0 ]
    and cd (cat $resultfile)
    commandline -f repaint
    rm -f $resultfile
  end

  function __fzfcmd
    set -q FZF_TMUX; or set FZF_TMUX 1

    if [ $FZF_TMUX -eq 1 ]
      if set -q FZF_TMUX_HEIGHT
        echo "fzf-tmux -d$FZF_TMUX_HEIGHT"
      else
        echo "fzf-tmux -d40%"
      end
    else
      echo "fzf"
    end
  end

  bind \ct '__fzf_insert_child_file'
  bind \cg '__fzf_insert_any_file'
  bind \cr '__fzf_fuzzy_history_search'
  #bind \ec '__fzf_fuzzy_chdir'

  if bind -M insert > /dev/null 2>&1
    bind -M insert \ct '__fzf_insert_child_file'
    bind -M insert \cg '__fzf_insert_any_file'
    bind -M insert \cr '__fzf_fuzzy_history_search'
    #bind -M insert \ec '__fzf_fuzzy_chdir'
  end
end
