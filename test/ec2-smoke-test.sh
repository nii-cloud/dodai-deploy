#!/bin/bash

function test_image {
  echo "Begin to test image $1."

  export ec2_image_id=$1

  output="`rake dodai:ec2 nodes_size=1 server_port=$port`"
  echo "$output"
  
  dns_names=( `echo "$output" | grep "dns name" | awk '{print $4}'` )
  dns_name=${dns_names[0]}
  
  instance_ids=(`echo "$output" | grep "instance id" | awk '{print $4}'` )
  
  test/smoke-test.sh $dns_name $port
  
  for instance_id in ${instance_ids[@]}
  do
    rake dodai:ec2:terminate instance=$instance_id
  done

  echo "Test of image $1 finished."
  echo ""
}

current_dir=`dirname $0`/
cd $current_dir/..

port=3000
if [ "$1" != "" ]; then
  port=$1
fi

for image_id in ami-d6b400d7 ami-c4c97ec5 ami-fa9723fb
do
  test_image $image_id
done
