#!/bin/bash

# This script is for creating a service file that will launch a Sample server
# NOTE: this script depends on install-kitura.sh

echo "creating sample-server.service"
cd $HOME

cat >$HOME/sample-server.service << EOF
[Unit]
Description=Sample Kitura Server

[Service]
ExecStart=$HOME/SampleServer/.build/debug/SampleServer
Restart=on-abort

[Install]
WantedBy=multi-user.target
EOF

echo "starting sample-server.service"
cp sample-server.service /etc/systemd/system
systemctl enable sample-server.service
systemctl start sample-server.service
