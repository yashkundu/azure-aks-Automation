#!/bin/bash
# cluster will automatically shut in 30 minutes.
sleep 1800
status=$(cat clusterState)

if [ "$status" = "started" ]; then
    # Succesfully stopping
    echo "stopping" > clusterState
    ./logger.sh Cluster stopping initiated

    success=$(./changeBackend.sh rhime http://localhost:3000)

    if [ "$success" = "false" ]
    then    
        echo "error" > clusterState
        ./logger.sh Error occured inside stopCluster - changeBackend request
        exit 1
    fi

    ./logger.sh Falcon url changed to localhost:3000
    # stopping the aks cluster

    ./logger.sh Sending the stop request to the cluster
    res=$(az aks stop --name rhimecluster --resource-group RhimeGroup)
    ./stopChecker.sh
    # start some cron job to track change
    exit 0
else 
    echo "error" > clusterState
    ./logger.sh Error occured inside stopCluster.sh

    exit 1
    # show some error, that try again
fi