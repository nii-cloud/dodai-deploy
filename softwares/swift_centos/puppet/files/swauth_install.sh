#!/bin/bash

cd /tmp/swift

tar -xzf /tmp/swift/swauth.tar.gz

cd /tmp/swift/swauth

python setup.py build

python setup.py install

if [ ! $? = 0 ]; then
  echo "failed to install swauth."
fi
