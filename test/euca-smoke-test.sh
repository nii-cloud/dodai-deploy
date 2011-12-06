#!/bin/bash

cd `dirname $0`

port=3000
if [ "$1" != "" ]; then
  port=$1
fi

./ec2-test-image.sh $ec2_image_id
