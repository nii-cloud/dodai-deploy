#!/bin/bash

function setup_physical {
  apt-get install xfsprogs -y
  mkdir -p $storage_path/$storage_dev
  sh -c "echo '/dev/$storage_dev $storage_path/$storage_dev xfs noatime,nodiratime,nobarrier,logbufs=8 0 0' >> /etc/fstab"
  mount $storage_path/$storage_dev
}

function setup_loopback {
  apt-get install xfsprogs -y
  mkdir -p $storage_path/$storage_dev
  dd if=/dev/zero of=/srv/swift-disk bs=1024 count=0 seek=${size}000000
  mkfs.xfs -i size=1024 /srv/swift-disk
  sh -c "echo '/srv/swift-disk $storage_path/$storage_dev xfs loop,noatime,nodiratime,nobarrier,logbufs=8 0 0' >> /etc/fstab"
  mount $storage_path/$storage_dev
}

function print_usage {
  name=`basename $0`
  echo "Usage:
  $name physical \$storage_path \$storage_dev
  OR
  $name loopback \$storage_path \$storage_dev \$size
  size: device size in GB

For example: 
  $name physical /srv/node sdb1
  $name loopback /srv/node sdb1 4
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
storage_path=$1
storage_dev=$2
size=$3

setup_$device_type
