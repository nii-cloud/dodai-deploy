#!/bin/bash

output=`ps aux`
echo $output | grep swift-account
if [ $? = 0 ]; then
    echo "swift-account was installed."
    exit 0
fi

chown -R swift:swift /srv/node

swift-init object-server start
swift-init object-replicator start
swift-init object-updater start
swift-init object-auditor start
swift-init container-server start
swift-init container-replicator start
swift-init container-updater start
swift-init container-auditor start
swift-init account-server start
swift-init account-replicator start
swift-init account-auditor start
