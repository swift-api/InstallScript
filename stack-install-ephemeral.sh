#!/bin/bash

# This script is for unnatended installs during system boot up

# set -e if you want the shell script to exit immediately will any commands fail.
set +e

echo "Installing Kitura during system startup"

./stack-install-dependencies.sh

# Setting enviromental variables
echo "Setting enviromental variables"

if [ ! -d "$HOME" ]; then
  export HOME=/root
  echo "Setting HOME to $HOME"
fi

if [[ -z "$SWIFT_SNAPSHOT" ]]; then
  export SWIFT_SNAPSHOT=DEVELOPMENT-SNAPSHOT-2016-05-09-a
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

#if [[ -z "$SPM_BRANCH" ]]; then
#  export SPM_BRANCH=master
#  echo "Setting SPM_BRANCH to $SPM_BRANCH"
#else
#  echo "SPM_BRANCH is set to $SPM_BRANCH";
#fi

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

# Getting swift version as a variable
cd $SWIFTENV_ROOT
SWIFT_VERSION=$(<version)
echo "Swift version is set to $SWIFT_VERSION"

# Install Swift compiler
# that will probably fail if we're switching between different versions of swift
if [[ "$SWIFT_VERSION" -ne "$SWIFT_SNAPSHOT" ]]; then 
  swiftenv install $SWIFT_SNAPSHOT
fi

# Build & Install swift-corelibs-libdispatch
echo "Build & Install swift-corelibs-libdispatch"

cd $HOME

if [ ! -d "$HOME/swift-corelibs-libdispatch" ]; then
  git clone --recursive -b $CORELIBS_LIBDISPATCH_BRANCH https://github.com/apple/swift-corelibs-libdispatch.git
  cd swift-corelibs-libdispatch  
else
  cd $HOME/swift-corelibs-libdispatch
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