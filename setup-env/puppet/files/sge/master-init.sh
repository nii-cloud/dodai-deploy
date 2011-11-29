#!/bin/bash

fqdn=`hostname -f`

#Register admin host
qconf -ah $fqdn

#Register submit host
qconf -as $fqdn

#Register executive hosts
for server in `cat /tmp/sge/slave-servers`
do
  qconf -ah $server
  qconf -ae $server
  echo "Add executive host:$server"
done

exit 0

