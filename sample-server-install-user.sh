#!/bin/bash

# If any commands fail, we want the shell script to exit immediately.
set -e

# NOTE: this script depends on install-server-ephemeral.sh
source ./sample-server-install-ephemeral.sh

# Preserve enviromental variables
echo "Preserving enviromental variables"

if [[ -z "$SOURCE_BRANCH" ]]; then
  echo "SOURCE_BRANCH is not set"
  exit 1
else
  echo "SOURCE_BRANCH is set to $SOURCE_BRANCH";
  echo "export SOURCE_BRANCH=$SOURCE_BRANCH" >> ~/.bashrc
fi