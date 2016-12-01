function __fzf_ctrl_e
	fish -c "fasd -l" | __fzfcmd -m | __fzfescape | read -l selects
  and commandline -i "$selects"
  commandline -f repaint
end
