#!/bin/bash

MY_HOST=`hostname`

#Register admin host
qconf -ah $MY_HOST

#Register submit host
qconf -as $MY_HOST

#Register executive hosts
for server in `cat /tmp/sge/sge-slave-servers`
do
	qconf -ae $server
	echo "Add executive host:$server"
done

exit 0

