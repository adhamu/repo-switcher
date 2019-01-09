#!/usr/bin/env bash

set -e

function usage() {
    echo '
    This script will change the remote origin of your git repositories.
    It will look for repositories inside the directory the script is run from.
    You are able to change them to github, bitbucket or gitlab.
    It assumes that the repositories already exist remotely on the target service.

    -o [old service] - this can be a search term as it is input to grep
    -n [new service] - can be github, bitbucket or gitlab
    -u [username] - your username for the new service
    -x [no-confirm] (Optional) - Do not prompt for each repo, just move it. Be careful

    example: ./'$(basename "$0")' -o [old service] -n [new service - github|bitbucket|gitlab] -u [new service username]
    example: ./'$(basename "$0")' -o gitlab -n github -u adhamu
'
}

while getopts 'o:n:u:x' flag; do
    case "${flag}" in
        o) OLD_GIT_SERVICE="${OPTARG}" ;;
        n) TARGET_GIT_SERVICE="${OPTARG}" ;;
        u) TARGET_GIT_SERVICE_USERNAME="${OPTARG}" ;;
        x) NO_CONFIRM="true" ;;
        *) usage
           exit 1
           ;;
    esac
done

if [ -z "${OLD_GIT_SERVICE}" ] || [ -z "${TARGET_GIT_SERVICE}" ] || [ -z "${TARGET_GIT_SERVICE_USERNAME}" ]; then
    echo "WARNING: You must supply the old git service name, the new git service name and the new git service username"
    usage
    exit 1
fi

case "$TARGET_GIT_SERVICE" in
    'github') TARGET_GIT_SERVICE_URL="https://github.com" ;;
    'bitbucket') TARGET_GIT_SERVICE_URL="https://bitbucket.org" ;;
    'gitlab') TARGET_GIT_SERVICE_URL="https://gitlab.com" ;;
    *) echo "Target service must be github, bitbucket or gitlab"
       exit 1
       ;;
esac

for PROJECT in `ls ./` ; do
    if [ -d $PROJECT ]; then
        pushd "$PROJECT" > /dev/null

        if [ -d ".git" ]; then
            if git remote -v | grep -qE "${OLD_GIT_SERVICE}" --color=always; then

                CONFIRM=""

                if [ -z $NO_CONFIRM ]; then
                    echo -n "${PROJECT} is on ${OLD_GIT_SERVICE}, move to ${TARGET_GIT_SERVICE}? [y/n] "
                    read CONFIRM
                fi

                if [ "$CONFIRM" == "y" ] || [ -n "$NO_CONFIRM" ]; then
                    echo "Moving ${PROJECT} to ${TARGET_GIT_SERVICE}"
                    git remote rm origin
                    git remote add origin "${TARGET_GIT_SERVICE_URL}/${TARGET_GIT_SERVICE_USERNAME}/${PROJECT}.git"
                    git fetch
                    git pull --all
                    git push -u --all
                fi

            fi
        fi

        popd > /dev/null
    fi
done
