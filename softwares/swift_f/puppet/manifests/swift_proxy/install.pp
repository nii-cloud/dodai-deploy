class swift_f::swift_proxy::install {
    include swift_f::common

    package { 
        [swauth, memcached, swift, python-swiftclient]:
            require => User[swift];

        swift-proxy:
            require => [File["/etc/swift/swift.conf"], Package[swift]]
    }

    file {
        "/etc/swift/proxy-server.conf":
            content => template("$proposal_id/etc/swift/proxy-server.conf.erb"),
            mode => 644,
            require => Package[swift-proxy];

        "/tmp/swift/storage-servers":
            content => template("swift_f/storage-servers.erb");

        "/tmp/swift/proxy-init.sh":
            source => "puppet:///modules/swift_f/proxy-init.sh",
            require => File["/etc/swift/proxy-server.conf", "/tmp/swift"];
    }

    exec {
        "/tmp/swift/proxy-init.sh $storage_dev $ring_builder_replicas 2>&1":
            require => File["/tmp/swift/proxy-init.sh", "/tmp/swift/storage-servers"]
    }
}
