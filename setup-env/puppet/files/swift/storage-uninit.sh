#!/bin/bash

storage_path=$1
storage_dev=$2

swift-init object-server stop
swift-init object-replicator stop
swift-init object-updater stop
swift-init object-auditor stop
swift-init container-server stop
swift-init container-replicator stop
swift-init container-updater stop
swift-init container-auditor stop
swift-init account-server stop
swift-init account-replicator stop
swift-init account-auditor stop

rm -rf $storage_path/$storage_dev/*
rm -rf /etc/swift/*

exit 0
