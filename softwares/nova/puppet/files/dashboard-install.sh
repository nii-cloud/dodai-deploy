#!/bin/bash

home=`dirname $0`
cd $home

tar xzvf osdb.tgz > /dev/null
cd osdb

if [ -f /etc/apt/apt.conf.d/proxy ]; then
  proxy=`echo \`cat /etc/apt/apt.conf.d/proxy\` | sed -e "s/.*\(http:\/\/[0-9a-zA-Z\:\.]\+\).*/\1/g"`
  if [ "$proxy" -a $(expr "$proxy" : "^http://[0-9a-zA-Z:.]\+$") -eq ${#proxy} ]; then
    export "http_proxy="$proxy
  fi
fi

sh run_tests.sh
