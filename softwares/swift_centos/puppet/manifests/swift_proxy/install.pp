class swift_centos::swift_proxy::install {
    include swift_centos::common::install

    package { 
        [memcached, openstack-swift]:;

        openstack-swift-proxy:
            require => [File["/etc/swift/swift.conf"], Package[openstack-swift]]
    }

    file {
        "/etc/swift/proxy-server.conf":
            content => template("$proposal_id/etc/swift/proxy-server.conf.erb"),
            mode => 644,
            require => Package[openstack-swift-proxy];

        "/tmp/swift/storage-servers":
            content => template("swift_centos/storage-servers.erb");

        "/tmp/swift/proxy-init.sh":
            source => "puppet:///modules/swift_centos/proxy-init.sh",
            require => File["/etc/swift/proxy-server.conf", "/tmp/swift"];

        "/tmp/swift/swauth.tar.gz":
            source => "puppet:///modules/swift_centos/swauth.tar.gz",
            mode => 644,
            require => File["/tmp/swift"];

        "/tmp/swift/swauth_install.sh":
            source => "puppet:///modules/swift_centos/swauth_install.sh",
            require => File["/tmp/swift"];
    }

    exec {
        "/tmp/swift/proxy-init.sh $storage_dev $ring_builder_replicas 2>&1":
            require => [Exec["/tmp/swift/swauth_install.sh"], File["/tmp/swift/proxy-init.sh", "/tmp/swift/storage-servers"]];

        "/tmp/swift/swauth_install.sh":
            require => File["/tmp/swift/swauth.tar.gz", "/tmp/swift/swauth_install.sh"];
    }
}
