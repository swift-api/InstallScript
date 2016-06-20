#!/bin/bash

# set -e if you want the shell script to exit immediately will any commands fail.
set -e

# NOTE: this script depends on install-kitura-ephemeral.sh
source ./stack-install-ephemeral.sh

# Preserve enviromental variables
echo "Preserving enviromental variables"
echo "# Running install Kitura as a user" >> ~/.bashrc

if [[ -z "$SWIFT_SNAPSHOT" ]]; then
  echo "SWIFT_SNAPSHOT is not set"
  exit 1
else
  echo "SWIFT_SNAPSHOT is set to $SWIFT_SNAPSHOT";
  echo "export SWIFT_SNAPSHOT=$SWIFT_SNAPSHOT" >> ~/.bashrc
fi

if [[ -z "$CORELIBS_LIBDISPATCH_BRANCH" ]]; then
  echo "CORELIBS_LIBDISPATCH_BRANCH is not set"
  exit 1
else
  echo "CORELIBS_LIBDISPATCH_BRANCH is set to $CORELIBS_LIBDISPATCH_BRANCH";
  echo "export CORELIBS_LIBDISPATCH_BRANCH=$CORELIBS_LIBDISPATCH_BRANCH" >> ~/.bashrc
fi

#if [[ -z "$SPM_BRANCH" ]]; then
#  echo "SPM_BRANCH is not set"
#  exit 1
#else
#  echo "SPM_BRANCH is set to $SPM_BRANCH";
#  echo "export SPM_BRANCH=$SPM_BRANCH" >> ~/.bashrc
#fi

if [[ -z "$SWIFTENV_ROOT" ]]; then
  echo "SWIFTENV_ROOT is not set"
  exit 1
else
  echo "SWIFTENV_ROOT is set to $SWIFTENV_ROOT";
  echo "export SWIFTENV_ROOT=$SWIFTENV_ROOT" >> ~/.bashrc
  echo "export PATH=$SWIFTENV_ROOT/bin:$PATH" >> ~/.bashrc
  echo 'eval "$(swiftenv init -)"' >> ~/.bashrc
fi
