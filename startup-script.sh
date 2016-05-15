#! /bin/bash
apt-get update
apt-get install -y git

if [ ! -d "./InstallScript" ]; then
  git clone https://github.com/swift-api/InstallScript.git
else
  cd ./InstallScript
  git pull
fi
source ./InstallScript/install-kitura-onstartup.sh
source ./InstallScript/install-server-onstartup.sh
source ./InstallScript/sample-server-service.sh