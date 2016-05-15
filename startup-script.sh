#! /bin/bash
apt-get install -qq -y git

if [ ! -d "./InstallScript" ]; then
  git clone -b final-swift-25042016 https://github.com/swift-api/InstallScript.git
else
  cd ./InstallScript
  git pull
fi
pushd .
source ./InstallScript/install-kitura-onstartup.sh
popd
pushd .
source ./InstallScript/install-server-onstartup.sh
popd
pushd .
source ./InstallScript/sample-server-service.sh
popd