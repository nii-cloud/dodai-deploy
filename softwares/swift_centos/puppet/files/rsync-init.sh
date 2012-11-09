#!/bin/bash

run="/var/run/rsyncd.pid"
if [ -e $run ]; then
    echo "rsync is running."
    exit 0
fi

echo "RSYNC_ENABLE=true" > /etc/default/rsync

rsync --daemon --config=/etc/rsyncd.conf
