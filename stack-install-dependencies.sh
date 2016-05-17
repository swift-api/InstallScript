#!/bin/bash

# This script is for unnatended installs during system boot up

# set -e if you want the shell script to exit immediately will any commands fail.
set +e

# Updating system
echo "Updating system"

# -qq is a switch for a `quiet` mode. Remove them if debugging
sudo apt-get -qq update
sudo apt-get -qq upgrade -y

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
# We are using pure Swift driver for mongo so following are not strictly required.
# However OpenSSL ic common dependency hence I'm leaving it for now
echo "MongoDB dependancies"
sudo apt-get -qq install -y pkg-config
sudo apt-get -qq install -y libssl-dev
sudo apt-get -qq install -y libsasl2-dev