#/bin/bash

export GITHUB_TOKEN=<PERSONAL ACCESS TOKEN - NEEDS REPO ACCESS>
export USERNAME=<Your GH Username>
export REPONAME=<Your REPO name>

# List all the PR numbers you want to change
for PR in 23 24 25 26 27 28 
do
  curl -X PATCH \
       -H "Authorization: token ${GITHUB_TOKEN}" \
       https://api.github.com/repos/${USERNAME}/${REPONAME}/pulls/${PR} \
       --data  '{ "base": "main" }'
done 

