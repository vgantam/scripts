#!/bin/bash

# Syncing with upstream
# By vishnu

git remote | grep upstream >> /dev/null 2>&1

if [ "$?" != "0" ]; then
        printf "Adding upstream git repo\n"
        git remote add upstream git@github.com:vishnunaidu/scripts.git
else
        printf "\n"
fi

git pull && \
  git fetch upstream && \
  git merge upstream/master -m "Merge remote-tracking branch 'upstream/master'" && \
  git push

printf "\n"
# pre-commit hook
dir_exist rubyLint-pre-commit pre-commit


# post-commit hooks
# please maintain the order for the commits to be installed. First one will have highest proority and changing the order will make some post-commits to fail
postCommits="git-post-commit \
            artifactProperty-post-commit"

dir_exist post-commit post-commit

# installing actual post-commits in post-commit.d
if [[ ! -d "/chef-repo-qa/.git/hooks/post-commit.d" ]]; then
  mkdir /chef-repo-qa/.git/hooks/post-commit.d
fi

counter=1
for i in $postCommits;
do
  hookLocation=/chef-repo-qa/.git/hooks/post-commit.d
  sourceLocation=/chef-repo-qa/.chef

  source=$i
  hook=$i

  if [ -f "$hookLocation/$counter-$hook" ]; then
    echo "$hook exist. Nothing to do"
  else
    echo "Installing $hook"
    `ln -sf $sourceLocation/$source $hookLocation/$counter-$hook`
  fi
  ((counter++))
done
