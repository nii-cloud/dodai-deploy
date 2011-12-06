#!/bin/bash

cd `dirname $0` 

port=3000
if [ "$1" != "" ]; then
  port=$1
fi

for image_id in ami-d6b400d7 ami-c4c97ec5 ami-fa9723fb
do
  ./ec2-test-image.sh $image_id
done
