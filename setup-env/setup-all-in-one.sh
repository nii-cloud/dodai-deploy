#!/bin/bash

apt-get update
apt-get install git -y
git clone http://github.com/nii-cloud/dodai-deploy

cd dodai-deploy/setup-env
./setup.sh -x "$http_proxy" server
./setup.sh -s `hostname -f` -x "$http_proxy" node
./setup-storage-for-swift.sh loopback /srv/node sdb1 4

cd ..
script/start-servers production
