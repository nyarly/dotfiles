function direnv_ps1
	set -l prompt 'd '
  if test (count $argv) -ge 1;
    set prompt $argv[1]
  end
  if test ! -z "$DIRENV_DIR" ;
    switch "$DIRENV_LAYOUT"
      case      c;            term_fcolor   555;
      case      erlang;       term_fcolor   0faf8d;
      case      go;           term_fcolor   a89b4d;
      case      java;         term_fcolor   b07219;
      case      javascript;   term_fcolor   f15501;
      case      node;         term_fcolor   f15501;
      case      python;       term_fcolor   3581ba;
      case      ruby;         term_fcolor   701516;
      case      shell;        term_fcolor   5861ce;
      case      vim;          term_fcolor   199c4b;
      case      rust;         term_fcolor   dea584;
      case      '*';            term_fcolor   aaa;
    end
  end
  echo -n $prompt
end
