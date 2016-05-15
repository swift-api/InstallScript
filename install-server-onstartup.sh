#!/bin/bash

# This script is for unnatended installs during system boot up

# If any commands fail, we want the shell script to exit immediately.
set +e

# NOTE: this script depends on install-kitura.sh

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

# Kill server if it's already running
# this script runs on boot, no need for that
#pkill SampleServer

# Running sample server code
cd $HOME
echo "Running SampleServer"
$HOME/SampleServer/.build/debug/SampleServer