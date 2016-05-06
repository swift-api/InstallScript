#!/bin/bash

# This script is for unnatended installs during system boot up

# If any commands fail, we want the shell script to exit immediately.
set +e

echo "Installin Kitura in boot only mode"

# Updating system
echo "Updating system"

sudo apt-get -qq update
sudo apt-get -qq upgrade -y

# Setting enviromental variables
echo "Setting enviromental variables"

if [ ! -d "$HOME" ]; then
  export HOME=/root
fi

if [[ -z "$SWIFT_SNAPSHOT" ]]; then
  export SWIFT_SNAPSHOT=DEVELOPMENT-SNAPSHOT-2016-04-25-a
  echo "Setting SWIFT_SNAPSHOT to $SWIFT_SNAPSHOT"
else
  echo "SWIFT_SNAPSHOT is set to $SWIFT_SNAPSHOT";
fi

if [[ -z "$CORELIBS_LIBDISPATCH_BRANCH" ]]; then
  export CORELIBS_LIBDISPATCH_BRANCH=experimental/foundation
  echo "Setting CORELIBS_LIBDISPATCH_BRANCH to $CORELIBS_LIBDISPATCH_BRANCH"
else
  echo "CORELIBS_LIBDISPATCH_BRANCH is set to $CORELIBS_LIBDISPATCH_BRANCH";
fi

if [[ -z "$SPM_BRANCH" ]]; then
  export SPM_BRANCH=master
  echo "Setting SPM_BRANCH to $SPM_BRANCH"
else
  echo "SPM_BRANCH is set to $SPM_BRANCH";
fi

# Installing system dependancies
echo "Installing system dependancies"

# Swift dependancies
echo "Swift dependancies"
sudo apt-get -qq install -y libcurl4-gnutls-dev
sudo apt-get -qq install -y gcc-4.8
sudo apt-get -qq install -y g++-4.8
sudo apt-get -qq install -y libcurl3
sudo apt-get -qq install -y libkqueue-dev
sudo apt-get -qq install -y openssh-client
sudo apt-get -qq install -y automake
sudo apt-get -qq install -y libbsd-dev
sudo apt-get -qq install -y git
sudo apt-get -qq install -y build-essential
sudo apt-get -qq install -y libtool
sudo apt-get -qq install -y clang
sudo apt-get -qq install -y libicu-dev
sudo apt-get -qq install -y curl
sudo apt-get -qq install -y libglib2.0-dev
sudo apt-get -qq install -y libblocksruntime-dev
sudo apt-get -qq install -y vim
sudo apt-get -qq install -y wget
sudo apt-get -qq install -y telnet

# Kitura dependancies
echo "Kitura dependancies"
sudo apt-get -qq install -y openjdk-7-jdk
sudo apt-get -qq install -y libhttp-parser-dev
sudo apt-get -qq install -y libhiredis-dev
sudo apt-get -qq install -y libcurl4-openssl-dev

sudo apt-get -qq install -y autoconf
sudo apt-get -qq install -y libtool
sudo apt-get -qq install -y libkqueue-dev
sudo apt-get -qq install -y libkqueue0
sudo apt-get -qq install -y libdispatch-dev
sudo apt-get -qq install -y libdispatch0
sudo apt-get -qq install -y libhttp-parser-dev
sudo apt-get -qq install -y libcurl4-openssl-dev
sudo apt-get -qq install -y libhiredis-dev
sudo apt-get -qq install -y libbsd-dev

# MongoDB dependancies
echo "MongoDB dependancies"
sudo apt-get -qq install -y pkg-config
sudo apt-get -qq install -y libssl-dev
sudo apt-get -qq install -y libsasl2-dev

# Installing swiftenv
echo "Installing swiftenv"

cd $HOME

if [ ! -d "$HOME/.swiftenv" ]; then
  git clone https://github.com/kylef/swiftenv.git ~/.swiftenv
else
  cd $HOME/.swiftenv
  git pull
fi

if [[ -z "$SWIFTENV_ROOT" ]]; then
  export SWIFTENV_ROOT=$HOME/.swiftenv
  echo "Setting SWIFTENV_ROOT to $SWIFTENV_ROOT"
  export PATH="$SWIFTENV_ROOT/bin:$PATH"
  eval "$(swiftenv init -)"
else
  echo "SWIFTENV_ROOT is set to $SWIFTENV_ROOT";
fi

# Install Swift compiler
swiftenv install $SWIFT_SNAPSHOT
swiftc -version

# NOTE: following block of code is not neded currently, yet it will remain for the timebeing 

# Getting swift version as a variable
#cd $SWIFTENV_ROOT
#SWIFT_VERSION=$(<version)
#echo "Swift version is set to $SWIFT_VERSION"

# Build & Install swift-corelibs-libdispatch
echo "Build & Install swift-corelibs-libdispatch"

cd $HOME

if [ ! -d "$HOME/swift-corelibs-libdispatch" ]; then
  git clone -b $CORELIBS_LIBDISPATCH_BRANCH https://github.com/swift-api/swift-corelibs-libdispatch.git
#  
  cd swift-corelibs-libdispatch
  git submodule init
  git submodule update   
else
  cd swift-corelibs-libdispatch
  git pull
fi

echo "Autogen"
source ./autogen.sh
echo "configure with toolchain at $SWIFTENV_ROOT/versions/$SWIFT_SNAPSHOT/usr"
./configure --with-swift-toolchain=$SWIFTENV_ROOT/versions/$SWIFT_SNAPSHOT/usr --prefix=$SWIFTENV_ROOT/versions/$SWIFT_SNAPSHOT/usr && make && make install

# Build & Install Swift Package Manager
#echo "Build & Install Swift Package Manager"
#
#cd $HOME
#
#if [ ! -d "$HOME/swift-package-manager" ]; then
#  git clone -b $SPM_BRANCH https://github.com/apple/swift-package-manager.git
#  cd swift-package-manager/  
#else
#  cd swift-package-manager/
#  git pull
#fi
#git checkout tags/swift-$SWIFT_SNAPSHOT
#./Utilities/bootstrap --prefix $SWIFTENV_ROOT/versions/$SWIFT_SNAPSHOT/usr install

# Installing sample server code
echo "Installing SampleServer"

if [[ -z "$SOURCE_BRANCH" ]]; then
  echo "Setting SOURCE_BRANCH"
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