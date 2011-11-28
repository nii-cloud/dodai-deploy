#!/bin/bash

current_dir=`dirname $0`/
cd $current_dir/..

server=$1
port=3000
if [ "$2" != "" ]; then
  port=$2
fi

echo "Create proposals."
./cli.rb --port $port $server proposal create nova "openstack nova diablo" 
./cli.rb --port $port $server proposal create glance "openstack glance diablo" 
./cli.rb --port $port $server proposal create swift "openstack swift diablo"
./cli.rb --port $port $server proposal create hadoop "hadoop 0.20.2"

for id in 1 2 3 4
do
  echo "Install for proposal $id."
  ./cli.rb --port $port $server proposal install $id
done

for id in 1 2 3 4
do
  echo "Test for proposal $id."
  ./cli.rb --port $port $server proposal test $id
done
