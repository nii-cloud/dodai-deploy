#!/bin/bash

MY_HOST=`hostname -f`

#Register admin host
qconf -ah $MY_HOST

#Register submit host
qconf -as $MY_HOST

#Register executive hosts
for server in `cat /tmp/sge/slave-servers`
do
  qconf -ah $server
  qconf -ae $server
  echo "Add executive host:$server"
done

exit 0

