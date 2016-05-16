#!/bin/bash

# set -e if you want the shell script to exit immediately will any commands fail.
set -e

# NOTE: this script depends on install-kitura.sh
source ./install-kitura-ephemeral.sh

# Preserve enviromental variables
echo "Preserving enviromental variables"

if [[ -z "$SWIFT_SNAPSHOT" ]]; then
  echo "SWIFT_SNAPSHOT is not set"
  exit 1
else
  echo "SWIFT_SNAPSHOT is set to $SWIFT_SNAPSHOT";
  echo "export SWIFT_SNAPSHOT=$SWIFT_SNAPSHOT" >> ~/.bashrc
fi

if [[ -z "$UBUNTU_VERSION" ]]; then
  export UBUNTU_VERSION=ubuntu15.10
  echo "Setting UBUNTU_VERSION to $UBUNTU_VERSION"
  echo "export UBUNTU_VERSION=$UBUNTU_VERSION" >> ~/.bashrc
else
  echo "UBUNTU_VERSION is set to $UBUNTU_VERSION";
fi

if [[ -z "$UBUNTU_VERSION_NO_DOTS" ]]; then
  export UBUNTU_VERSION_NO_DOTS=ubuntu1510
  echo "Setting UBUNTU_VERSION_NO_DOTS to $UBUNTU_VERSION_NO_DOTS"
  echo "export UBUNTU_VERSION_NO_DOTS=$UBUNTU_VERSION_NO_DOTS" >> ~/.bashrc
else
  echo "UBUNTU_VERSION_NO_DOTS is set to $UBUNTU_VERSION_NO_DOTS";
fi

if [[ -z "$CORELIBS_LIBDISPATCH_BRANCH" ]]; then
  export CORELIBS_LIBDISPATCH_BRANCH=experimental/foundation
  echo "Setting CORELIBS_LIBDISPATCH_BRANCH to $CORELIBS_LIBDISPATCH_BRANCH"
  echo "export CORELIBS_LIBDISPATCH_BRANCH=$CORELIBS_LIBDISPATCH_BRANCH" >> ~/.bashrc
else
  echo "CORELIBS_LIBDISPATCH_BRANCH is set to $CORELIBS_LIBDISPATCH_BRANCH";
fi

if [[ -z "$SPM_BRANCH" ]]; then
  export SPM_BRANCH=master
  echo "Setting SPM_BRANCH to $SPM_BRANCH"
  echo "export SPM_BRANCH=$SPM_BRANCH" >> ~/.bashrc
else
  echo "SPM_BRANCH is set to $SPM_BRANCH";
fi



# Installing swiftenv
echo "Installing swiftenv"

cd $HOME

if [ ! -d "$HOME/.swiftenv" ]; then
  git clone https://github.com/kylef/swiftenv.git ~/.swiftenv
fi

if [[ -z "$SWIFTENV_ROOT" ]]; then
  export SWIFTENV_ROOT=$HOME/.swiftenv
  echo "export SWIFTENV_ROOT=$SWIFTENV_ROOT" >> ~/.bashrc
  echo "Setting SWIFTENV_ROOT to $SWIFTENV_ROOT"
  
  export PATH="$SWIFTENV_ROOT/bin:$PATH"
  echo "export PATH=$SWIFTENV_ROOT/bin:$PATH" >> ~/.bashrc
  
  eval "$(swiftenv init -)"
  echo 'eval "$(swiftenv init -)"' >> ~/.bashrc
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