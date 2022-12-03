#!/bin/bash
# checks if the cluster has completely started

checkStarted(){
	res=$(az aks show --name rhimecluster --resource-group RhimeGroup)
	powerState=$(echo $(echo $res | jq '. | .powerState.code') | tr -d '"')
	provisioningState=$(echo $(echo $res | jq '. | .provisioningState') | tr -d '"')
	if [ "$powerState" = "Running" ] && [ "$provisioningState" = "Succeeded" ]; then
		echo "true"
	else
		echo "false"
	fi
}

for i in {1..5}
do
    sleep 60
    started=$(checkStarted)

    if [ "$started" = "true" ]
    then
        # cluster has started
        echo "started" > clusterState
        ./logger.sh Cluster started successfully

        ip=$(echo $(kubectl get service gateway -o json) | jq '. | .status.loadBalancer.ingress[0].ip' | tr -d '"')

        url="http://${ip}:80"
        ./logger.sh Got cluster ip - $url

        success=$(./changeBackend.sh rhime $url)

        if [ "$success" = "false" ]
        then    
            echo "error" > clusterState
            ./logger.sh Error occured in startChecker.sh changeBackend request

            exit 1
        fi

        ./logger.sh Successfully changed the falcons proxy url to - $url
        ./stopCluster.sh > /dev/null &
        exit 0

    fi
done

# cluster cannot be started some error
echo "error" > clusterState
./logger.sh Error occured inside startChecker.sh
exit 1