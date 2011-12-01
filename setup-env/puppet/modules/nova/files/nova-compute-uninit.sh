#!/bin/bash

# terminate instances
if [ "`which virsh`" != "" ]; then
    for instance_id in `virsh list | grep -e "[0-9]" | gawk '{print $2}'`
    do
        echo "Instance ID: $instance_id"
        echo `virsh destroy $instance_id`
    done
fi

rm -rf /var/lib/nova/*

exit 0
