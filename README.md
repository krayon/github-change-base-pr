# Change base branch of all Pull Requests #

## _PRIVATE PROJECT, NOT A PRODUCT OF [GitHub](https://github.com/)_ ##

## Links to docs ##

* [API call to update pull request](https://developer.github.com/v3/pulls/#update-a-pull-request)

* [Creating a Personal Access Token](https://help.github.com/en/github/authenticating-to-github/creating-a-personal-access-token-for-the-command-line#creating-a-token)

## The Script ##

If you want to change from `master` to `main` for your default branch but have
a bunch of `pull requests` waiting to be reviewed and merged, those will no
doubt currently be pointing to `master` (if you merge to `master` all the time.

Simply replace `main` above with whatever branch you want to change the `pull
requests` to.

```
# ./change-pr-base.sh --help

Usage: change-pr-base.sh [<GITHUB_REPO_API_URL>]

GITHUB_REPO_API_URL can also be set as an environment variable and has the
format:
    https://api.github.com/repos/<ORG-OR-USER>/<REPO>
or:
    https://github.example.com/api/v3/repos/<ORG-OR-USER>/<REPO>

For github.com you can instead set GITHUB_USER and GITHUB_REPO if you prefer.

Regardless of which you choose above, you will also need GITHUB_TOKEN set.

You can also optionally set the following for the old and new base branches
respectively:

  * GITHUB_BASE_OLD
  * GITHUB_BASE_NEW

```

## Example run ##

1. Make new `main` branch, based on `master`
2. Set `main` as the default branch
3. Run this:

```
$ export GITHUB_TOKEN=yeahrightnicetrynotmine
$ export GITHUB_USER=krayon
$ export GITHUB_REPO=testchange
$ ./change-pr-base.sh

Enter a list of Pull Request numbers to target to 'master'
Enter 1 or more PR numbers seperated with a space
(or * for all PRs based on <main>): *
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 49588  100 49588    0     0  84556      0 --:--:-- --:--:-- --:--:-- 84477
{
  "url": "https://api.github.com/repos/krayon/testchange/pulls/3",
  ...
  "changed_files": 1
}
{
  "url": "https://api.github.com/repos/krayon/testchange/pulls/2",
  ...
  "changed_files": 1
}
{
  "url": "https://api.github.com/repos/krayon/testchange/pulls/1",
  ...
  "changed_files": 1
}
```

4. Delete `master`

## Notes ##

This script is a simple api call that will change your provided list of `pull
requests` to retarget to the new `main` branch. Or whatever branch you want.

Hope this is helpful.
