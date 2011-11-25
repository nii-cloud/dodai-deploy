#!/bin/bash

HOME="/tmp/glance"

#check if glance-api is running
service glance-api status | grep running
if [ $? != 0 ]; then
    echo "Service glance-api is not started."
    exit 1
fi

service glance-registry status | grep running
if [ $? != 0 ]; then
    echo "Service glance-registry is not started."
    exit 1
fi

echo "Test finished. It is OK."
