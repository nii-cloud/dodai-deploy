#!/bin/bash

current_dir=`dirname $0`/
cd $current_dir/..

server=$1

echo "Create proposals."
rake dodai:cli server=$server resource=proposal action=create name=nova software_desc="openstack nova diablo"
rake dodai:cli server=$server resource=proposal action=create name=glance software_desc="openstack glance diablo"
rake dodai:cli server=$server resource=proposal action=create name=swift software_desc="openstack swift diablo"
rake dodai:cli server=$server resource=proposal action=create name=hadoop software_desc="hadoop 0.20.2"

for id in 1 2 3 4
do
  echo "Install for proposal $id."
  rake dodai:cli server=$server resource=proposal action=install id=$id

  echo "Test for proposal $id."
  rake dodai:cli server=$server resource=proposal action=test id=$id
done
