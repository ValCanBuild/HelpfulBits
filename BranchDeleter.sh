# Deletes all merged git branches older than the provided date.

#!/bin/sh

date=$1 #Format: 2015-01-15
require_confirmation=$2 # 0 - don't require confirmation; 1 - require confirmation
DRY_RUN=0

DeleteBranch() {
  echo "Deleting branch $1"
  if [ "$DRY_RUN" -eq 0 ]; then
    git push origin ":$1"
  fi
}

echo "Deleting git branches older than $date"
for branch in $(git branch --remote --merged); do
  # has there been any action on this branch since this date
  if [ "$(git log $branch --since $date | wc -l)" -eq 0 ]; then
    local_branch_name=$(echo "$branch" | sed 's/^origin\///')
    if [ $require_confirmation -eq 1 ]; then
      read -p "Are you sure you want to delete branch $local_branch_name? " -n 1 -r
      echo
      if [[ $REPLY =~ ^[Yy]$ ]]; then
        DeleteBranch $local_branch_name
      fi
    else
      DeleteBranch $local_branch_name
    fi
  fi
done
