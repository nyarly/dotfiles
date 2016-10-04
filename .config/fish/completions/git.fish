# extra fish completion for git

if test -f /usr/share/fish/completions/git.fish
  source /usr/share/fish/completions/git.fish
end

if test -f /usr/local/share/fish/completions/git.fish
  source /usr/local/share/fish/completions/git.fish
end

complete -f -c git -n '__fish_git_needs_command' -a savepoint-merge -d 'Merge a branch, creating a savepoint first'
complete -f -c git -n '__fish_git_needs_command' -a savepoint-reset -d 'Fall back to a savepoint, clean up a bad merge'
complete -f -c git -n '__fish_git_needs_command' -a savepoint-review -d 'Review changes in a merge - usually happens automatically'
complete -f -c git -n '__fish_git_needs_command' -a savepoint-complete -d 'Approve a merge - removes savepoint, pushes to origin'

complete -f -c git -n '__fish_git_using_command savepoint-merge' -a '(git branch -r | grep -v HEAD | sed "s/^[[:space:]]*//")' -d 'Remote branch'

complete -f -c git -n '__fish_git_needs_command' -a jira-branch -d 'Add configuration to the branch that tracks a Jira issue'
complete -f -c git -n '__fish_git_using_command jira-branch' -a '(__cached_jira_issues)'
