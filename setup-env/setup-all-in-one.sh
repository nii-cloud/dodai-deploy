#!/bin/bash

git clone https://github.com/nii-cloud/dodai-deploy
cd dodai-deploy/setup-env
./setup.sh server
./setup.sh -s `hostname -f` node
./setup-storage-for-swift.sh loopback /srv/node sdb1 4
cd ..
script/start-servers production
