#!/bin/bash

cd `dirname $0`

#Add users that are allowed to access SGE
qconf -au `whoami` arusers

#Add queue configuration
qconf -Aq test-queue.conf

#Execute test command
qsub -now y test-example.sh

if [ $? != 0 ]; then
    echo "Test failed."
    exit 1
fi

echo "Test finished. It is OK."
