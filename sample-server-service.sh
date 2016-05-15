#!/bin/bash

# This script is for creating a service file that will launch a Sample server
# NOTE: this script depends on install-kitura.sh

cat >$HOME/sample-server.service << EOF
[Unit]
Description=Sample Kitura Server

[Service]
ExecStart=$HOME/SampleServer/.build/debug/SampleServer
Restart=on-abort

[Install]
WantedBy=multi-user.target
EOF