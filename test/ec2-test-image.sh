#!/bin/bash

function test_image {
  echo "Begin to test image $1 - $2."

  export ec2_image_id=$2
  os_ver=$1

  output="`rake dodai:ec2 nodes_size=1 server_port=$port`"
  if [ $? != 0 ]; then
    echo "Test failed."
    exit 1
  fi
  echo "$output"

  dns_names=( `echo "$output" | grep "dns name" | awk '{print $4}'` )
  dns_name=${dns_names[0]}

  instance_ids=(`echo "$output" | grep "instance id" | awk '{print $4}'` )

  test/smoke-test.sh $os_ver $dns_name $port
  result=$?

  if [ $result != 0 ]; then
    script/cli.rb --port=$port $dns_name log list
  fi

  for instance_id in ${instance_ids[@]}
  do
    rake dodai:ec2:terminate instance=$instance_id
  done
  if [ $result != 0 ]; then
    echo "Test for image[$1 - $2] failed."
    exit 1
  fi

  echo "Test of image[$1 - $2] finished."
  echo ""
}

if [ "$port" = ""  ]; then
  port=3000
fi

cd `dirname $0`/..
test_image $@
