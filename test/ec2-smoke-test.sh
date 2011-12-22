#!/bin/bash

cd `dirname $0` 

port=3000
if [ "$1" != "" ]; then
  port=$1
fi

for image_id in ami-d6b400d7 ami-fab004fb ami-7c90277d
do
  ./ec2-test-image.sh $image_id
done
