#!/bin/bash

status=$(cat clusterState)

if [ "$status" = "starting" ]; then

    # starting the aks cluster
    ./logger.sh Sending the start request to the cluster
    res=$(az aks start --name rhimecluster --resource-group RhimeGroup)
    ./startChecker.sh
    exit 0
else 
    echo "error" > clusterState
    ./logger.sh Error occured inside startCluster.sh
    exit 1
fi