#!/bin/bash

HOME="/tmp/glance"

#check if glance-api is running
status glance-api | grep running
if [ $? != 0 ]; then
    echo "Service glance-api is not started."
    exit 1
fi

apt-get install gawk -y

pid1="`status glance-api | awk '{print $4}'`"
sleep 2
pid2="`status glance-api | awk '{print $4}'`"
if [ $pid1 != $pid2 ]; then
    echo "Service glance-api's pid is changing."
    exit 1
fi

status glance-registry | grep running
if [ $? != 0 ]; then
    echo "Service glance-registry is not started."
    exit 1
fi

pid1="`status glance-registry | awk '{print $4}'`"
sleep 2
pid2="`status glance-registry | awk '{print $4}'`"
if [ $pid1 != $pid2 ]; then
    echo "Service glance-registry's pid is changing."
    exit 1
fi

export OS_TENANT_NAME=$1
export OS_USERNAME=$2
export OS_PASSWORD=$3
export OS_AUTH_URL="http://localhost:5000/v2.0/"

glance index
if [ $? != 0 ]; then
    echo "Image list can't be retrieved."
    exit 1
fi


echo "Test finished. It is OK."
