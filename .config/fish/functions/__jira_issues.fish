function __jira_issues
	set -l username $JIRA_USERNAME
  set -l password $JIRA_PASSWORD
  set -l jql $JIRA_JQL
  set -l jarfile $JIRA_JARFILE
  set -l server $JIRA_SERVER
  set -l extra_jql 'and assignee = currentUser()'

  if test -z $username
    set username (git config --get jira.user)
    if test $status -ne 0
      return 1
    end
  end

if test -z $password
  set password (git config --get jira.password)
  if test $status -ne 0
    return 1
end
end

if test -z $jarfile
  set jarfile (git config --get jira.jarfile)
  if test $status -ne 0
    return 1
end
 end

 if test -z $server
   set server (git config --get jira.server)
   if test $status -ne 0
     return 1
end
end

if test -z $jql
  set jql (git config --get jira.jql)
  if test $status -ne 0
    return 1
end
end

java -jar "$jarfile" --server "$server" --user "$username" --password "$password" --action getIssueList --columns key,summary,status --jql "$jql $extra_jql" | sed -E 's/^"|"$//g' | awk -F '"*,"*' 'NR > 2 && NF == 3 { print $1 "	" $2 " [" $3 "]" }'
end
