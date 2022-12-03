#!/bin/bash
# Once stopped the cluster can only be run after half an hour
sleep 1800

state=$(cat clusterState)

if [ "$state" = "locked" ]
then
    ./logger Releasing lock of the cluster
    echo "stopped" > clusterState
fi
