#!/bin/bash

MY_HOST=`hostname`
SLAVE_NODES=$1
echo "###################################:${SLAVE_NODES}"

#Register admin host
qconf -ah $MY_HOST

#Register submit host
qconf -as $MY_HOST

#Register executive hosts
qconf -ae $MY_HOST  #for TEST

exit 0

