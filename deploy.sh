#!/bin/bash

echo -e "\033[0;32mDeploying updates to GitLab ..\033[0m"

# cache le password durant 2 heures (7200 secondes)
git config --global credential.helper 'cache --timeout=7200'

git add .

# Commit changes.
msg="rebuilding site `date`"
if [ $# -eq 1 ]
  then msg="$1"
fi
git commit -m "$msg"

# Push source and build repos.
git push origin master
