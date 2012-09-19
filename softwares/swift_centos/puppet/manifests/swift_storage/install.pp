class swift_centos::swift_storage::install {
    include swift_centos::common::install

    package {
        [openstack-swift, openstack-swift-account, openstack-swift-container, openstack-swift-object, xfsprogs, rsync]:
            require => File["/etc/swift/swift.conf"]
    }

    file {
        "/etc/rsyncd.conf":
            content => template("$proposal_id/etc/rsyncd.conf.erb"),
            mode => 644,
            require => Package[rsync];

       "/tmp/swift/rsync-init.sh":
           source => "puppet:///modules/swift_centos/rsync-init.sh",
           require => File["/etc/rsyncd.conf", "/tmp/swift"];

        "/etc/swift/account-server.conf":
            content => template("$proposal_id/etc/swift/account-server.conf.erb"),
            mode => 644,
            alias => "account-server.conf",
            require => Package[openstack-swift-account];

        "/etc/swift/container-server.conf":
            content => template("$proposal_id/etc/swift/container-server.conf.erb"),
            mode => 644,
            alias => "container-server.conf",
            require => Package[openstack-swift-container];

        "/etc/swift/object-server.conf":
            content => template("$proposal_id/etc/swift/object-server.conf.erb"),
            mode => 644,
            alias => "object-server.conf",
            require => Package[openstack-swift-object];

        "/tmp/swift/storage-init.sh":
            source => "puppet:///modules/swift_centos/storage-init.sh",
            require => File["account-server.conf", "container-server.conf", "object-server.conf", "/tmp/swift"];
    }

    exec {
        "/tmp/swift/rsync-init.sh 2>&1":
            alias => "rsync-init",
            require => File["/tmp/swift/rsync-init.sh"];

        "/tmp/swift/storage-init.sh $swift_proxy 2>&1":
            require => [File["/tmp/swift/storage-init.sh"], Exec["rsync-init"]]
    }
}
