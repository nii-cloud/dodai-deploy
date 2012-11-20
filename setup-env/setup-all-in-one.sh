#!/bin/bash
if [ "`which apt-get`" != "" ]; then
  apt-get update
  apt-get install git -y
elif [ "`which yum`" != ""  ]; then
  yum install git -y
else
  echo "The application apt-get or yum doesn't exist. Please check your OS."
  exit 1
fi

git clone http://github.com/nii-cloud/dodai-deploy

cd dodai-deploy/setup-env
if [ "$http_proxy" != "" ]; then
  ./setup.sh -x "$http_proxy" server
  ./setup.sh -s `hostname -f` -x "$http_proxy" node
else
  ./setup.sh server
  ./setup.sh -s `hostname -f` node
fi

./setup-storage-for-swift.sh loopback /srv/node sdb1 4

cd ..
script/start-servers production
