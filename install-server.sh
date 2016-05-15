#!/bin/bash

# If any commands fail, we want the shell script to exit immediately.
set +e

# NOTE: this script depends on install-kitura.sh

# Installing sample server code
echo "Installing SampleServer"

if [[ -z "$SOURCE_BRANCH" ]]; then
  echo "Setting SOURCE_BRANCH"
  echo 'export SOURCE_BRANCH=master' >> ~/.bashrc
  export SOURCE_BRANCH=master
else
  echo "SOURCE_BRANCH is set to '$SOURCE_BRANCH'";
fi

cd $HOME

if [ ! -d "$HOME/SampleServer" ]; then
  git clone -b $SOURCE_BRANCH https://github.com/swift-api/SampleServer.git
  cd $HOME/SampleServer
else
  cd $HOME/SampleServer
  git pull
  rm -Rf Packages/
fi

make

# before running our code we need to manualy copy some libraries - that is a temporary fix
sudo ln -s $HOME/SampleServer/.build/debug/libCHttpParser.so /usr/lib/libCHttpParser.so
sudo ln -s $HOME/SampleServer/.build/debug/libCHiredis.so /usr/lib/libCHiredis.so

# Kill server if it's already running
pkill SampleServer

# Running sample server code
cd $HOME
echo "Running SampleServer"
$HOME/SampleServer/.build/debug/SampleServer

# install Golang
#sudo apt-get -qq install golang
#export GOROOT=/usr/lib/go
#export PATH=$PATH:$GOROOT/bin
#go get github.com/adnanh/webhook

# refresh script
# checkout?
#cd $HOME
#cd kitura-server/
#git pull
#rm -Rf Packages/
#make