#!/bin/bash

path=`dirname $0`
cd $path
echo $path
if [ ! -e hadoop ]; then
  tar xzvf hadoop-*.tar.gz > /dev/null
  mv hadoop-*/ hadoop
fi
