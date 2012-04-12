#!/bin/bash

swift-init proxy-server status
if [ $? = 0 ]; then
    echo "swift-proxy was installed."
    exit 0
fi

dpkg -i /tmp/swift/python-swauth.deb

cd /etc/swift

dev=$1

swift-ring-builder account.builder create 18 $2 1
swift-ring-builder container.builder create 18 $2 1
swift-ring-builder object.builder create 18 $2 1

zone=1
for server in `cat /tmp/swift/storage-servers`
do
    swift-ring-builder account.builder add z$zone-$server:6002/$dev 100
    swift-ring-builder container.builder add z$zone-$server:6001/$dev 100
    swift-ring-builder object.builder add z$zone-$server:6000/$dev 100

    zone=`expr $zone + 1`
done

swift-ring-builder account.builder rebalance
swift-ring-builder container.builder rebalance
swift-ring-builder object.builder rebalance

chown -R swift:swift /etc/swift

swift-init proxy start
