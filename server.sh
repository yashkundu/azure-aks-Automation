#!/bin/bash

./init.sh

handleRequest(){

	read line
	echo $line

	status=$(cat clusterState)

	if [ "$status" = "stopped" ]
	then
		echo "starting" > clusterState
		./logger.sh Starting the cluster &
		./startCluster.sh > /dev/null &
		echo -e "HTTP/1.1 200\r\nContent-Type: text/html\r\n\r\n$(cat starting.html)" > response
	elif [ "$status" = "starting" ]
	then
		./logger.sh Cluster is already starting &
		echo -e "HTTP/1.1 200\r\nContent-Type: text/html\r\n\r\n$(cat starting.html)" > response
	elif [ "$status" = "stopping" ]
	then
		./logger.sh Cluster is currently stopping &
		echo -e "HTTP/1.1 200\r\nContent-Type: text/html\r\n\r\n$(cat stopping.html)" > response
	elif [ "$status" = "locked" ]
	then
		./logger.sh Cluster is currently locked &
		echo -e "HTTP/1.1 200\r\nContent-Type: text/html\r\n\r\n$(cat locked.html)" > response
	else
		./logger.sh Error occured inside server.sh &
		echo -e "HTTP/1.1 200\r\nContent-Type: text/html\r\n\r\n$(cat error.html)" > response
	fi
}

echo 'Server listening on port 3000 ... '

./logger.sh Starting server at port 3000 &

while true; do
	cat response | nc -lN 3000 | handleRequest
done