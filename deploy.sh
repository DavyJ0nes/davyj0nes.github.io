#!/bin/bash
set -eu

if [[ $(git status -s) ]]
then
		echo "There are uncommited changes. Please commit any pending changes."
		exit 1;
fi

echo "Deleting old publication"
rm -rf public
mkdir public
git worktree prune
rm -rf .git/worktrees/public/

echo "Checking out master branch into public"
git worktree add -B master public origin/master

echo "Removing existing files"
rm -rf public/*

echo "Generating site"
hugo

echo "Updating master branch"
cd public && git add --all && git commit -m "Publishing to master (deploy.sh)"

echo "Deploying master branch"
git push origin master
