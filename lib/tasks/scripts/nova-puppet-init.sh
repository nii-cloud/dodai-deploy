#!/bin/bash

target_file="/etc/puppet/modules/nova/files/image_kvm.tgz"
if [ ! -e $target_file ]; then
  image="ttylinux-uec-amd64-12.1_2.6.35-22_1.tar.gz"
  wget http://smoser.brickies.net/ubuntu/ttylinux-uec/$image
  mv $image $target_file 
fi

target_file="/etc/puppet/modules/nova/files/osdb.tgz"
if [ ! -e $target_file ]; then
  apt-get -y install bzr
  bzr branch lp:horizon/diablo -r 46 osdb
  tar cvzf /opt/osdb.tgz osdb > /dev/null
  rm -rf osdb
fi
