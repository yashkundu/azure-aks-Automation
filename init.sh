#!/bin/bash

rm -f response
mkfifo response

rm -f clusterState
touch clusterState
echo "stopped" > clusterState

rm -f file.log
touch file.log