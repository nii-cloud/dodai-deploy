class swift::swift_proxy::install {
    include swift::common

    package { swift: }

    package {
        [swift-proxy, memcached]:
            require => [File["/etc/swift/swift.conf"], Package[swift]]
    }

    file {
        "/etc/swift/proxy-server.conf":
            content => template("$proposal_id/etc/swift/proxy-server.conf.erb"),
            mode => 644,
            require => Package[swift-proxy];

        "/tmp/swift/storage-servers":
            content => template("swift/storage-servers.erb");

        "/tmp/swift/proxy-init.sh":
            source => "puppet:///modules/swift/proxy-init.sh",
            require => File["/etc/swift/proxy-server.conf", "/tmp/swift"];

        "/tmp/swift/python-swauth.deb":
            source => "puppet:///modules/swift/python-swauth_1.0.2-1_all.deb",
            require => File["/tmp/swift"];
    }

    exec {
        "/tmp/swift/proxy-init.sh $storage_dev $ring_builder_replicas 2>&1":
            require => File["/tmp/swift/proxy-init.sh", "/tmp/swift/storage-servers", "/tmp/swift/python-swauth.deb"]
    }
}
