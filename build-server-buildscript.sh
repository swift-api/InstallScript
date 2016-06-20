#! /bin/bash

# run as root
set -e

export BUCKET_NAME=build-server-bucket
export BRANCH=master
export BUILD_DATE=`date +%d%m%Y`
export SERVER_NAME=stack-server-$BRANCH-$BUILD_DATE

# run as user
# 1. create use
# 2. switch to user

password=$(perl -e 'print crypt("SwiftBackendCollective", "password")')
useradd -m -p $password swift-stack

# build swift
./stack-install-dependencies.sh

# master
sudo -u swift-stack ./stack-install-ephemeral.sh

# development
#source ./stack-install-user.sh

# create disk image:

# create and mount temporary drive
sudo mkdir /mnt/tmp
sudo mkfs.ext4 -F /dev/disk/by-id/google-build-server-temporary
sudo mount -o discard,defaults /dev/disk/by-id/google-build-server-temporary /mnt/tmp

# make image of primary drive on temporary one
sudo dd if=/dev/disk/by-id/google-build-server of=/mnt/tmp/disk.raw bs=4096
cd /mnt/tmp
sudo tar czvf stack-server-image.tar.gz disk.raw

# copy to the bucket and clean
gsutil cp /mnt/tmp/stack-server-image.tar.gz gs://$BUCKET_NAME/$BRANCH/stack-server
sudo rm /mnt/tmp/stack-server-image.tar.gz
sudo rm /mnt/tmp/disk.raw

# create image
gcloud compute images create $SERVER_NAME --source-uri gs://$BUCKET_NAME/$BRANCH/stack-server-image.tar.gz
#gcloud compute images create stack-server-master-17052016 --source-uri gs://build-server-bucket/master/stack-server/stack-server-image.tar.gz

# create new template 
gcloud compute --project "slacket-11" instance-templates create $SERVER_NAME --machine-type "n1-standard-2" --network "default" --metadata-from-file startup-script=./sample-server-startup-script.sh --maintenance-policy "MIGRATE" --scopes default="https://www.googleapis.com/auth/cloud-platform" --tags "http-server","https-server","kitura","sample-server","sample-worker" --image $SERVER_NAME --boot-disk-size "10" --boot-disk-type "pd-standard" --boot-disk-device-name $SERVER_NAME

# update instance group

# build sample-server
sudo -u $SWIFT_USER ./sample-server-install-ephemeral.sh
#source ./sample-server-install-user.sh

# upload sample server to bucket

# reload instance-group

# terminate
sudo poweroff