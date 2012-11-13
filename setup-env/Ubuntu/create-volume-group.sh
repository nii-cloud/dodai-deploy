#!/bin/bash

function setup_physical {
  apt-get install lvm2 -y
  vgcreate $volume_group_name $device_path
}

function setup_loopback {
  apt-get install lvm2 -y
  dd if=/dev/zero of=$file_path bs=1024 count=0 seek=${size}000000
  loop_device=`losetup -f`
  if [ $? != 0 ]; then
    echo $loop_device
    echo "Loopback devices are unavailable."
    exit 1
  fi

  losetup $loop_device $file_path
  vgcreate $volume_group_name $loop_device
}

function print_usage {
  name=`basename $0`
  echo "Usage:
  $name physical \$volume_group_name \$device_path
  OR
  $name loopback \$volume_group_name \$file_path \$size
  size: device size in GB

For example: 
  $name physical nova-volumes /dev/sdb1
  $name loopback nova-volumes /root/volume.data 4
"
}

device_type=$1
if [ "$device_type" = "physical" ]; then
  if [ $# -ne 3 ]; then
    print_usage
    exit 1
  fi
elif [ "$device_type" = "loopback" ]; then
  if [ $# -ne 4 ]; then
    print_usage
    exit 1
  fi
else
  print_usage
  exit 1
fi

shift
volume_group_name=$1
device_path=$2
file_path=$2
size=$3

setup_$device_type

vgs --noheadings -o name | grep $volume_group_name
if [ $? != 0 ]; then
  echo "Failed to create volume group $volume_group_name."
  exit 1
fi

echo "Volume group $volume_group_name was created."
