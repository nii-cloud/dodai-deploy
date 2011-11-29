#!/bin/bash

ME=`whoami`

#Add users that are allowed to access SGE
qconf -au $ME arusers

#Add queue configuration
qconf -Aq /tmp/sge/test-queue.cnf

#Execute test command
qsub -now y /tmp/sge/test-example.sh

if [ $? != 0 ]; then
    echo "Test failed."
    exit 1
fi

echo "Test finished. It is OK."
