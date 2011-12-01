#!/bin/bash

cd `dirname $0`

fqdn=`hostname -f`

#Register admin host
qconf -ah $fqdn

#Register submit host
qconf -as $fqdn

qconf -Ahgrp allhosts-group.conf

for server in `cat slave-servers`
do
  qconf -ae $server
  qconf -aattr hostgroup hostlist $server @allhosts
  echo "Add executive host:$server"
done

exit 0

