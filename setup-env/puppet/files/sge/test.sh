#!/bin/bash

ME=`whoami`

#Add users that are allowed to access SGE
qconf -au $ME arusers

SLAVE_NODES=()
for server in `cat /tmp/sge/sge-slave-servers`
do
  SLAVE_NODES=("${SLAVE_NODES[@]}" $server)
done

#Replace array to string
NODE_LIST=`echo "${SLAVE_NODES[@]}" | sed -e "s/ /,/g"`

echo "Test slave nodes:$NODE_LIST"

#Setting to configuration file 
sed -i -e "s/{hostlist}/$NODE_LIST/g" /tmp/sge/test_q.cnf

#Add queue configuration
qconf -Aq /tmp/sge/test_q.cnf

#Execute test command
qsub -now y /tmp/sge/example.sh

if [ $? != 0 ]; then
    echo "Service sun-grid-engine is failed."
    exit 1
fi

echo "Test finished. It is OK."
