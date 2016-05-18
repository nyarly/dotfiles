function __cached_jira_issues
  __cache_zap jira .git -atime +1h
  __cache_or_get jira .git '__jira_issues'
end
