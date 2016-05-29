ulimit -n 4096

source ~/.config/fish/functions/capture_status.fish
source ~/.config/fish/functions/notify_after_long.fish

set -eg EDITOR
set -g __fish_git_prompt_show_informative_status yes
set -x BROWSER chromium-browser
set -x CHROME_BIN /usr/bin/chromium

set -gx MANPATH "" $MANPATH

if test -f ~/.config/fish/private.fish
  source ~/.config/fish/private.fish
end

# The shell is my partner - it needs tools too:
eval (direnv hook fish)
source /usr/local/share/chruby/chruby.fish

source ~/.config/fish/functions/autotmux.fish
source ~/.config/fish/functions/_run_fasd.fish
source ~/.config/fish/nix.fish
source ~/.config/fish/go.fish
source ~/.config/fish/rust.fish

set -x fish_color_search_match  'normal' '--background=878787'

function fish_greeting
end

__refresh_gpg_agent_info

stty start undef
stty stop undef
stty -ixon
