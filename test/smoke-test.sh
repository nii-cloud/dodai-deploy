#!/bin/bash

function print_usage {
  name=`basename $0`
  echo "Usage: $name SERVER [PORT]

SERVER: IP address or dns name of deploy server.
PORT  : Port number of rails server in deploy server. Default value is 3000.
"
}

if [ "$1" = "" ]; then
  print_usage
  exit 1
fi

server=$1
port=3000

if [ "$2" != "" ]; then
  port=$2
fi

current_dir=`dirname $0`/
cd $current_dir/..

cli="script/cli.rb --port $port $server"

echo "Create proposals."
$cli proposal create nova "openstack nova diablo" 
$cli proposal create glance "openstack glance diablo" 
$cli proposal create swift "openstack swift diablo"
$cli proposal create hadoop "hadoop 0.20.2"
$cli proposal create sge "sun grid engine 6.2u5"

software_count=5
for id in `seq $software_count` 
do
  echo "Install proposal $id."
  $cli proposal install $id
done

for id in `seq $software_count`
do
  echo "Test proposal $id."
  $cli proposal test $id
done

while true 
do
  echo "Checking result of tests..."

  output="`$cli proposal list`"
  echo "$output"

  echo "$output" | grep "failed" > /dev/null
  if [ $? -eq 0 ]; then
    echo "Test failed."
    exit 1
  fi

  count=`echo "$output" | grep -c "tested"`

  if [ "$count" = "$software_count" ]; then
    break
  fi

  sleep 120 
done

for id in `seq $software_count`
do
  echo "Uninstall proposal $id."
  $cli proposal uninstall $id
done

while true
do
  echo "Checking result of uninstallations..."

  output="`$cli proposal list`"
  echo "$output"

  echo "$output" | grep "failed" > /dev/null
  if [ $? -eq 0 ]; then
    echo "Test failed."
    exit 1
  fi

  count=`echo "$output" | grep -c "init"`

  if [ "$count" = "$software_count" ]; then
    echo "Test succeeded."
    exit 0
  fi

  sleep 20
done
