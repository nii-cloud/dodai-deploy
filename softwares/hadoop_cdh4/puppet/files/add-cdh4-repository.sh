#!/bin/bash

cd `dirname $0`

dpkg -l cdh4-repository | grep ii
if [ `echo $?` -ne 0 ]; then
  dpkg -i cdh4-repository_1.0_all.deb
  apt-get update 
fi

exit 0
