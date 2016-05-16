# Using Vcsh and Myrepos

Bootstrapping a new machine:

Install the right tools:
  myrepos, vcsh, vim, tmux, reattach-to-user-namespace, ...

vcsh clone https://git.lrdesign.com/judson/vcsh-myrepos
cd ~/.config/mr
ls available.d
./enable_config.sh fish.vcsh git.vcsh vim.vcsh # e.g.
mr update

Establish links in ~/.config/tmux-local to the right platform
(Fix unicode/platform specific issues in fish, vim)

Done?
