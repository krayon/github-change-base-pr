# Change base branch of all Pull Requests

If you want to change from `master` to `main` for your default branch but have a bunch of `pull requests` waiting to be reviewed and merged, those will no doubt currently be pointing to `master` (if you merge to `master` all the time.

This script is a simple api call that will change all waiting `pull requests` to point to the new `main` branch. Or whatever branch you want. The line to change if `main` is not the target branch is:

```
--data  '{ "base": "main" }'
```

Simply replace `main` above with whatever branch you want to change the `pull requests` to.

For this script to run you'll need to fill in 3 variables

```
export GITHUB_TOKEN=
export USERNAME=
export REPONAME=
```

And in the for loop, a list of `pull request` numbers.

Hope this is helpful.
