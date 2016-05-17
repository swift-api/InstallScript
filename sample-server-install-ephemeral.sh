#!/bin/bash

# This script is for unnatended installs during system boot up

# If any commands fail, we want the shell script to exit immediately.
set +e

# NOTE: this script depends on stack-install-ephemeral.sh

# Installing sample server code
echo "Installing SampleServer"

if [[ -z "$SOURCE_BRANCH" ]]; then
  echo "Setting SOURCE_BRANCH"
  export SOURCE_BRANCH=master
else
  echo "SOURCE_BRANCH is set to '$SOURCE_BRANCH'"
fi

cd $HOME

if [ ! -d "$HOME/SampleServer" ]; then
  git clone -b $SOURCE_BRANCH https://github.com/swift-api/SampleServer.git
  cd $HOME/SampleServer
  make build
else
  cd $HOME/SampleServer
  git pull
  make refetch
  make build
fi

make

echo "patching /usr/lib"
# before running our code we need to manualy copy some libraries - that is a temporary fix
sudo ln -s $HOME/SampleServer/.build/debug/libCHttpParser.so /usr/lib/libCHttpParser.so
sudo ln -s $HOME/SampleServer/.build/debug/libCHiredis.so /usr/lib/libCHiredis.so

# Running sample server code
#cd $HOME
#$HOME/SampleServer/.build/debug/SampleServer