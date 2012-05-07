#!/bin/bash

cd `dirname $0` 

port=3000
if [ "$1" != "" ]; then
  port=$1
fi

./ec2-test-image.sh maverick ami-d6b400d7
./ec2-test-image.sh natty ami-fab004fb
./ec2-test-image.sh oneiric ami-7c90277d
./ec2-test-image.sh precise ami-2cc7772d 
