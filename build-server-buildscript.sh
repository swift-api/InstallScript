#! /bin/bash

# run as user
# 1. create use
# 2. switch to user

useradd -m ghost

# build swift
source ./stack-install-ephemeral.sh
#source ./stack-install-user.sh

# create disk image
sudo mkdir /mnt/tmp
sudo mkfs.ext4 -F /dev/disk/by-id/build-server-temporary
sudo mount -o discard,defaults /dev/disk/by-id/build-server-temporary /mnt/tmp

sudo dd if=/dev/disk/by-id/build-server of=/mnt/tmp/stack-disk.raw bs=4096
cd /mnt/tmp
sudo tar czvf stack-server-disk.tar.gz stack-disk.raw
cp /mnt/tmp/czvf stack-server-disk.tar.gz gs://$BUCKET_NAME/$IMAGE_DIR

# build sample-server
sudo -u $SWIFT_USER ./sample-server-install-ephemeral.sh
#source ./sample-server-install-user.sh

# upload sample server to bucket

# terminate
sudo poweroff