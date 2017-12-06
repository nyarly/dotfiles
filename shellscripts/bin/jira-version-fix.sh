#!/usr/bin/env bash

currentversion="nv_$(git tag | grep '[.].*[.*]' | versiontool sort | tail -n 1)"

set -ex
for id in $(jira-cli view --search-jql 'project = SOUS AND status = Closed and fixVersion is EMPTY' --format '%key'); do
  jira-cli update --fix-version "$currentversion" "$id"
done
