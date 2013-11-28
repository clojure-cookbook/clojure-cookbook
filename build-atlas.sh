#!/usr/bin/env bash

set -e

function ask {
  read -n 1 -r -p "$1"
  if [ $REPLY == "y" ]; then
    return;
  else
    echo -e "\nAborted."
    exit
  fi
}

function open_build_page {
  if command -v open >/dev/null 2>&1; then
    open "http://ano-atlas2.herokuapp.com/books/1234000001500/builds/new"
  fi
  echo -e "\n[DONE] Visit http://ano-atlas2.herokuapp.com/books/1234000001500/builds/new to build the book"
}

# Increase the max post size for Atlas
git config http.postBuffer 524288000 > /dev/null

if git remote | grep atlas > /dev/null; then
  echo "Atlas remote detected"

  echo "Pulling any changes..."
  git fetch atlas

  git merge atlas/master

  if ask "Push to Atlas repository? [y/n] "; then
    echo -e "\nPushing..."
    git push atlas master
    open_build_page
  fi
else
  echo "Atlas remote not found"
  exit 1
fi
