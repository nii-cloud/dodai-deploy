#!/bin/bash

target_file="/etc/puppet/modules/nova_and_quantum_f/files/image_kvm.tgz"
if [ ! -e $target_file ]; then
  image="ttylinux-uec-amd64-12.1_2.6.35-22_1.tar.gz"
  wget http://smoser.brickies.net/ubuntu/ttylinux-uec/$image
  mv $image $target_file 
fi

if [ ! -e "/etc/puppet/modules/apt" ]; then
  git clone https://github.com/camptocamp/puppet-apt /etc/puppet/modules/apt
fi
