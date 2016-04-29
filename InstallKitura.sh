#!/bin/bash

# If any commands fail, we want the shell script to exit immediately.
set -e

# Set environment variables for image
# add at the end of ~/.bashrc

if [[ -z "$SWIFT_SNAPSHOT" ]]; then 
  echo "Setting SWIFT_SNAPSHOT"
  echo 'export SWIFT_SNAPSHOT=swift-DEVELOPMENT-SNAPSHOT-2016-03-24-a' >> ~/.bashrc 
  export SWIFT_SNAPSHOT=swift-DEVELOPMENT-SNAPSHOT-2016-03-24-a
else 
  echo "SWIFT_SNAPSHOT is set to '$SWIFT_SNAPSHOT'"; 
fi

if [[ -z "$UBUNTU_VERSION" ]]; then 
  echo "Setting UBUNTU_VERSION"
  echo 'export UBUNTU_VERSION=ubuntu15.10' >> ~/.bashrc 
  export UBUNTU_VERSION=ubuntu15.10
else 
  echo "UBUNTU_VERSION is set to '$UBUNTU_VERSION'"; 
fi

if [[ -z "$UBUNTU_VERSION_NO_DOTS" ]]; then 
  echo "Setting UBUNTU_VERSION_NO_DOTS"
  echo 'export UBUNTU_VERSION_NO_DOTS=ubuntu1510' >> ~/.bashrc 
  export UBUNTU_VERSION_NO_DOTS=ubuntu1510
else 
  echo "UBUNTU_VERSION_NO_DOTS is set to '$UBUNTU_VERSION_NO_DOTS'"; 
fi

if [[ -z "$CORELIBS_LIBDISPATCH_BRANCH" ]]; then 
  echo "Setting CORELIBS_LIBDISPATCH_BRANCH"
  echo 'export CORELIBS_LIBDISPATCH_BRANCH=master' >> ~/.bashrc 
  export CORELIBS_LIBDISPATCH_BRANCH=master
else 
  echo "CORELIBS_LIBDISPATCH_BRANCH is set to '$CORELIBS_LIBDISPATCH_BRANCH'"; 
fi

if [[ -z "$SPM_BRANCH" ]]; then 
  echo "Setting SPM_BRANCH"
  echo 'export SPM_BRANCH=master' >> ~/.bashrc 
  export SPM_BRANCH=master
else 
  echo "SPM_BRANCH is set to '$SPM_BRANCH'"; 
fi

cd $HOME

sudo apt-get update
sudo apt-get upgrade
sudo apt-get install -y libcurl4-gnutls-dev
sudo apt-get install -y gcc-4.8
sudo apt-get install -y g++-4.8
sudo apt-get install -y libcurl3
sudo apt-get install -y libkqueue-dev
sudo apt-get install -y openssh-client
sudo apt-get install -y automake
sudo apt-get install -y libbsd-dev
sudo apt-get install -y git
sudo apt-get install -y build-essential
sudo apt-get install -y libtool
sudo apt-get install -y clang
sudo apt-get install -y libicu-dev
sudo apt-get install -y curl
sudo apt-get install -y libglib2.0-dev
sudo apt-get install -y libblocksruntime-dev
sudo apt-get install -y vim
sudo apt-get install -y wget
sudo apt-get install -y telnet

# Install Swift compiler
wget https://swift.org/builds/development/$UBUNTU_VERSION_NO_DOTS/$SWIFT_SNAPSHOT/$SWIFT_SNAPSHOT-$UBUNTU_VERSION.tar.gz
tar xzvf $SWIFT_SNAPSHOT-$UBUNTU_VERSION.tar.gz

# add at the end of ~/.bashrc
# swift dir has to be at the begining of PATH as there is a clash with swift from openstack
export PATH=$HOME/$SWIFT_SNAPSHOT-$UBUNTU_VERSION/usr/bin:$PATH
echo 'export PATH=$HOME/$SWIFT_SNAPSHOT-$UBUNTU_VERSION/usr/bin:$PATH' >> ~/.bashrc 
swiftc -version

# Clone and install swift-corelibs-libdispatch
cd $HOME
git clone -b $CORELIBS_LIBDISPATCH_BRANCH https://github.com/apple/swift-corelibs-libdispatch.git
cd swift-corelibs-libdispatch
#git pull
git submodule init
git submodule update
sh ./autogen.sh
./configure --with-swift-toolchain=$HOME/$SWIFT_SNAPSHOT-$UBUNTU_VERSION/usr --prefix=$HOME/$SWIFT_SNAPSHOT-$UBUNTU_VERSION/usr
make
make install

# Clone and build Swift Package Manager
cd $HOME
git clone -b $SPM_BRANCH https://github.com/apple/swift-package-manager.git
cd swift-package-manager/
git checkout tags/$SWIFT_SNAPSHOT
./Utilities/bootstrap --prefix $HOME/$SWIFT_SNAPSHOT-$UBUNTU_VERSION/usr install
# Swift has been installed

# install Kitura
if [[ -z "$KITURA_BRANCH" ]]; then 
  echo "Setting KITURA_BRANCH"
  echo 'export KITURA_BRANCH=develop' >> ~/.bashrc 
  export KITURA_BRANCH=develop
else 
  echo "KITURA_BRANCH is set to '$KITURA_BRANCH'"; 
fi

sudo apt-get install -y openjdk-7-jdk
sudo apt-get install -y libhttp-parser-dev
sudo apt-get install -y libhiredis-dev
sudo apt-get install -y libcurl4-openssl-dev

# these files have to be modified. Move to gist
wget https://raw.githubusercontent.com/IBM-Swift/kitura-ubuntu-docker/master/clone_build_kitura.sh

sudo apt-get install -y autoconf
sudo apt-get install -y libtool
sudo apt-get install -y libkqueue-dev
sudo apt-get install -y libkqueue0
sudo apt-get install -y libdispatch-dev
sudo apt-get install -y libdispatch0
sudo apt-get install -y libhttp-parser-dev
sudo apt-get install -y libcurl4-openssl-dev
sudo apt-get install -y libhiredis-dev 
sudo apt-get install -y libbsd-dev

make build

# MongoDB
sudo apt-get install -y pkg-config
sudo apt-get install -y libssl-dev
sudo apt-get install -y libsasl2-dev
wget https://github.com/mongodb/mongo-c-driver/releases/download/1.3.0/mongo-c-driver-1.3.0.tar.gz
tar xzf mongo-c-driver-1.3.0.tar.gz
cd mongo-c-driver-1.3.0
./configure

# Hiredis
#sudo apt-get install -y libhiredis-dev

# check out sample source
if [[ -z "$SOURCE_BRANCH" ]]; then 
  echo "Setting SOURCE_BRANCH"
  echo 'export SOURCE_BRANCH=master' >> ~/.bashrc 
  export SOURCE_BRANCH=master
else 
  echo "SOURCE_BRANCH is set to '$SOURCE_BRANCH'"; 
fi

cd $HOME
git clone -b $SOURCE_BRANCH https://bitbucket.org/jakub-tomanik-tooploox/kitura-server.git

# install Golang
#sudo apt-get install golang
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