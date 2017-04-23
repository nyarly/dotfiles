# Dotfiles

There are many repos like this, but this one is mine.

This is a repository encompassing many VCSH repos, in order that they all be in one place.

The idea is to be able to
check out one repo,
edit a file,
run a script
and bingo, there's a machine configured.

## Theory of Operation

This repo incorporates many existing vcsh repos as subtrees.
Each is a branch with its own root.
Those branches are in turn merged here as subdirectories
with the same name as the branch
and the same intended vcsh name.

So, you should be able to
```
cd dotfiles-repo
git pull
vcsh clone file://dotfiles-repo.git -b repo repo
vcsh pull
vcsh repo commit -a
vcsh push
git push
```

c.f. [the git book](https://git-scm.com/book/en/v1/Git-Tools-Subtree-Merging) about subtrees.

## Helper Scripts

* `scripts/add-subtree <remote> <repo>` adds an existing git repo as a subtree.
* `scripts/convert-one <repo>` updates a single vcsh repo to point to this repo
* `scripts/convert-vcsh` runs over `vcsh list` and updates those repo to point here.
* `scripts/all-repos` emits a list of all the vcsh branches available
* `scripts/common-repos` lists the branches here that vcsh supports
* `scripts/vcsh-clone` reads from stdin a list of branches to vcsh clone.
* `scripts/pull-repo <repo>` pulls changes from a repo branch into master
* `scripts/pull-all` pulls changes from all repo branches into master

__(not done yet)__
* `scripts/vcsh-init <repo>` creates a new vcsh config that points to a matching branch.

## Related Tools

"Well, [VCSH](https://github.com/RichiH/vcsh) obviously.

[commute](https://github.com/nyarly/commute) is a nice complement to this repo,
since it dotfiles can get added to your commute list
so that you remember to do the `git push`.

## Notes about the implementation

Most of these repos are config files,
and as such contain hidden files.
**`ls -a` liberally!**


## Notes on specific branches

`fish` requires that `git` be checked out properly -
you'll want to `fisher install` after adding 'fish',
and if git fails, it'll fail and clean out the fishfile.

Likewise, you'll want to launch `nvim` and `:PlugInstall`
after pulling in the 'neovim' repo.

## Initial setup
```sh
git clone git@github.com/nyarly/dotfiles
cd dotfiles
scripts/all-repos > local-repos
vim local-repos # delete ones inappropriate to current machine
# install apps here - nvim, fish, direnv, etc
scripts/vcsh-clone < local-repos
```
