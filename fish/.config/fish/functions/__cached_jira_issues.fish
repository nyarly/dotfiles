function __cached_jira_issues
	__cache_zap jira .git -amin +60
  __cache_or_get jira .git '__jira_issues'
end
