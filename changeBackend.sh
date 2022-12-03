#!/bin/bash

varName=$1
url=$2

res=$(curl --location --request POST "http://localhost:9900/apiStatus/backendChange" --header "Content-Type: application/json" --data-raw '{ "varName": "'$varName'","url": "'$url'"}')

success=$(echo $res | jq '. | .body.success' | tr -d '"')

echo $success
