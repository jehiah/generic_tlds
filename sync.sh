#!/bin/bash
set -e

if [ "$(git config --get user.email)" == "" ]; then
    git config --global user.email "automatic-data-update@jehiah.cz"
    git config --global user.name "Data Update"
fi

./update_generic_tlds.sh

git add .
git status

FILES_CHANGED=$(git diff --staged --name-only | wc -l)
echo "FILES_CHANGED: ${FILES_CHANGED}"
# if more than one changed commit it
if [[ "${FILES_CHANGED}" -gt 1 ]]; then
    DT=$(TZ=America/New_York date "+%Y-%m-%d %H:%M")
    git commit -a -m "sync: ${DT}"
    git push origin master
fi
