#!/bin/bash

SLAVE_NODES=$1

#Add users that are allowed to access SGE
qconf -au root arusers

HOST_LIST=SLAVE_NODES[@]
echo "###################################:$HOST_LIST"
sed -i -e "s/{hostlist}/$HOST_LIST/g" /tmp/sge/test_q.cnf

#Add queue configuration
qconf -Aq /tmp/sge/test_q.cnf

#Execute test shell
/tmp/sge/test.sh


