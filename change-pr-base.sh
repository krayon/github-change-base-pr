#/bin/bash
# API call docs: https://developer.github.com/v3/pulls/#update-a-pull-request
# Creating a Personal Access Token: https://help.github.com/en/github/authenticating-to-github/creating-a-personal-access-token-for-the-command-line#creating-a-token

export GITHUB_TOKEN=<PERSONAL ACCESS TOKEN - NEEDS REPO ACCESS>
export USERNAME=<Your GH Username>
export REPONAME=<Your REPO name>

echo
echo    "Enter a list of Pull Request numbers to target to 'main'" 
echo -n "Enter 1 or more PR numbers seperated with a space: "
read PR_LIST

# List all the PR numbers you want to change
for PR in ${PR_LIST}
do
  curl -X PATCH \
       -H "Authorization: token ${GITHUB_TOKEN}" \
       https://api.github.com/repos/${USERNAME}/${REPONAME}/pulls/${PR} \
       --data  '{ "base": "main" }'
done 

