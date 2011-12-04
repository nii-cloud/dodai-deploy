#!/bin/bash

git clone https://github.com/nii-cloud/dodai-deploy
cd dodai-deploy/setup-env
./setup.sh server
./setup.sh -s `hostname -f` node
cd ..
script/start-servers
