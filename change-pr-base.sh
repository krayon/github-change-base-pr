#/bin/bash

# API call docs:
#     https://developer.github.com/v3/pulls/#update-a-pull-request

# Creating a Personal Access Token:
#   https://help.github.com/en/github/authenticating-to-github/creating-a-personal-access-token-for-the-command-line#creating-a-token

_github_token=""
_github_user=""
_github_repo=""
_github_url=""
_github_base_old=""
_github_base_new=""
[ ! -z "${GITHUB_TOKEN}"    ] && _github_token="${GITHUB_TOKEN}"
[ ! -z "${GITHUB_USER}"     ] && _github_user="${GITHUB_USER}"
[ ! -z "${GITHUB_REPO}"     ] && _github_repo="${GITHUB_REPO}"
[ ! -z "${GITHUB_BASE_OLD}" ] && _github_base_old="${GITHUB_BASE_OLD}"
[ ! -z "${GITHUB_BASE_NEW}" ] && _github_base_new="${GITHUB_BASE_NEW}"

showhelp() {
cat <<EOF
Usage: ${0##*/} [<GITHUB_REPO_API_URL>]

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
EOF
}



# Token required
[ -z "${_github_token}" ] && {

>&2 cat <<EOF
ERROR: Please set the environment variable GITHUB_TOKEN to your GitHub API
Token.
EOF
    >&2 showhelp
    exit 1
}

[ ${#} -gt 1 ] && {
    >&2 echo "ERROR: Too many parameters"
    >&2 showhelp
    exit 1
}

[ "${1}" == "--help" ] || [ "${1}" == "-h" ] || [ ${#} -gt 1 ] && {
    showhelp
    exit 0
}

# URL in variable
[ ! -z "${GITHUB_REPO_API_URL}" ] && _github_url="${GITHUB_REPO_API_URL}"

# URL on command line
[ ${#} -gt 0 ] && _github_url="${1}" && shift 1

# URL to be constructed (github.com assumed)
[ -z "${_github_url}" ] && {
    [ -z "${_github_user}" ] && {

>&2 cat <<EOF
ERROR: Please set the environment variable GITHUB_USER to your user or
Organization, or specify the full GitHub Repository API on the command line.
EOF

        >&2 showhelp
        exit 1
    }

    [ -z "${_github_repo}" ] && {

>&2 cat <<EOF
ERROR: Please set the environment variable GITHUB_REPO to your repository,
or specify the full GitHub Repository API on the command line.
EOF

        >&2 showhelp
        exit 1
    }

    _github_url="https://api.github.com/repos/${_github_user}/${_github_repo}"
}



# Usage: change_base_branch <PR> [<new_base>]
change_base_branch() {
    pr="${1}" && shift 1

    new_base="main"
    [ ${#} -gt 0 ] && new_base="${1}"

    curl \
        -X PATCH \
        -H "Authorization: token ${_github_token}" \
        "${_github_url}/pulls/${pr}" \
        --data  '{ "base": "'"${new_base}"'" }'
}

# Usage: change_all_base_branch [<new_base> [<old_base>]]
change_all_base_branch() {
    new_base="main"
    [ ${#} -gt 0 ] && new_base="${1}" && shift 1
    old_base="master"
    [ ${#} -gt 0 ] && old_base="${1}"

    (\
        while read line; do #{
            jq -r '.url + "|||" + .base.ref' <<<"${line}"
        done < <(\
            curl \
                -H "Authorization: token ${_github_token}" \
                -H "Content-Type:  application/json" \
                "${_github_url}/pulls" \
            |jq -c '.[]'
        )\
    )\
    |sed -n '/|||'"${old_base}"'$/s#\(^.*\)|||'"${old_base}"'$#\1#p' \
    |while read url; do #{
        curl \
            -X PATCH \
            -H "Authorization: token ${_github_token}" \
            "${url}" \
            --data '{"base":"'"${new_base}"'"}'
    done #}
}



echo
echo    "Enter a list of Pull Request numbers to target to 'main'" 
echo    "Enter 1 or more PR numbers seperated with a space"
echo -n "(or "*" for all PRs based on <master>): "
read pr_list

[ "${pr_list}" == "*" ] && {
    change_all_base_branch ${_github_base_new} ${_github_base_old}
    exit $?
}

# List all the PR numbers you want to change
for pr in ${pr_list}; do #{
    change_base_branch "${pr}" ${_github_base_new}
done #}

# vim:ts=4:tw=80:sw=4:et:ai:si
