#!/bin/bash

# This script is for unnatended installs during system boot up

# If any commands fail, we want the shell script to exit immediately.
set +e

# NOTE: this script depends on stack-install-ephemeral.sh

# Installing sample server code
echo "Installing Slacket"

if [[ -z "$SOURCE_BRANCH" ]]; then
  echo "Setting SOURCE_BRANCH"
  export SOURCE_BRANCH=development
else
  echo "SOURCE_BRANCH is set to '$SOURCE_BRANCH'"
fi

cd $HOME

if [ ! -d "$HOME/Slacket" ]; then
  git clone -b $SOURCE_BRANCH https://github.com/jtomanik/Slacket.git
  cd $HOME/Slacket
  make build
else
  cd $HOME/Slacket
  git pull
  make refetch
  make build
fi

# Running sample server code
#cd $HOME
#$HOME/Slacket/.build/debug/Slacket