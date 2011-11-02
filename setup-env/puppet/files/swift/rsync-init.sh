#!/bin/bash

output=`ps aux`
echo $output | grep rsync 
if [ $? = 0 ]; then
    echo "rsync was installed."
    exit 0
fi

sed -i -e "s/RSYNC_ENABLE.*/RSYNC_ENABLE=true/g" /etc/default/rsync
service rsync start
