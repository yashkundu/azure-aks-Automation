#!/bin/bash
# checks if the cluster has completely stopped

checkStopped(){
	res=$(az aks show --name rhimecluster --resource-group RhimeGroup)
	powerState=$(echo $(echo $res | jq '. | .powerState.code') | tr -d '"')
	provisioningState=$(echo $(echo $res | jq '. | .provisioningState') | tr -d '"')
	if [ "$powerState" = "Stopped" ] && [ "$provisioningState" = "Succeeded" ]; then
		echo "true"
	else
		echo "false"
	fi
}

for i in {1..5}
do
    sleep 60
    stopped=$(checkStopped)

    if [ "$stopped" = "true" ]
    then
        # cluster has stopped and locked
        echo "locked" > clusterState
        ./logger.sh Cluster successfully stopped and locked 
        ./releaseLock.sh > /dev/null &
        exit 0
    fi
done

# cluster cannot be started some error
echo "error" > clusterState
./logger.sh Error occured inside stopChecker.sh

exit 1