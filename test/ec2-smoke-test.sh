#!/bin/bash

current_dir=`dirname $0`/
cd $current_dir/..

port=3000
if [ "$1" != "" ]; then
  port=$1
fi

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
