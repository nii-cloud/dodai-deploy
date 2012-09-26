#!/bin/bash

version="0.20.2"
target_file="/etc/puppet/modules/hadoop/files/hadoop-$version.tar.gz"
if [ ! -e $target_file ]; then
  wget http://www.us.apache.org/dist/hadoop/common/hadoop-$version/hadoop-$version.tar.gz
  mv hadoop-$version.tar.gz $target_file
fi
