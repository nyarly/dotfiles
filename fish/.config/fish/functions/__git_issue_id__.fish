function __git_issue_id__ --argument pattern
	if test -z pattern
    set pattern "%s"
  end
	set -l path (git symbolic-ref HEAD ^/dev/null)
  if test $status -ne 0
    return 0
  end

  set -l current (echo $path | sed 's#^refs/heads/##')

  for config in jira-ticket pivotal-story github-issue
    set -l ids (git config --get-all "branch.$current.$config" | sort -u)
    if test (count $ids) -gt 0
      printf $pattern $ids[1]
      return 0
    end
  end

  return 1
end
