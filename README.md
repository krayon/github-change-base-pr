# Change base branch of all Pull Requests

## Links to docs

[API call to update pull request](https://developer.github.com/v3/pulls/#update-a-pull-request)

[Creating a Personal Access Token](https://help.github.com/en/github/authenticating-to-github/creating-a-personal-access-token-for-the-command-line#creating-a-token)

## The Script

If you want to change from `master` to `main` for your default branch but have a bunch of `pull requests` waiting to be reviewed and merged, those will no doubt currently be pointing to `master` (if you merge to `master` all the time.

Simply replace `main` above with whatever branch you want to change the `pull requests` to.

For this script to run you'll need to fill in 3 variables

```
export GITHUB_TOKEN=
export USERNAME=
export REPONAME=
```

And in the `for loop`, a list of `pull request` numbers that you provide when asked at run time.

This script is a simple api call that will change your provided list of `pull requests` to retarget to the new `main` branch. Or whatever branch you want. The line to change if `main` is not the target branch is:

```
--data  '{ "base": "main" }'
```


Hope this is helpful.
