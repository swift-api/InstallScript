#!/bin/bash

# This script is for creating a service file that will launch a Sample server
# NOTE: this script depends on install-kitura.sh

echo "creating sample-server.service"
cd $HOME

cat >$HOME/slacket.service << EOF
[Unit]
Description=Sample Server

[Service]
ExecStart=$HOME/Slacket/.build/debug/Slacket
Restart=on-abort

[Install]
WantedBy=multi-user.target
EOF

echo "starting sample-server.service"
cp sample-server.service /etc/systemd/system
systemctl enable sample-server.service
systemctl start sample-server.service
