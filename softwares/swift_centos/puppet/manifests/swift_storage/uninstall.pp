class swift_centos::swift_storage::uninstall {
    include swift_centos::common::uninstall

    package {
        [openstack-swift-account, openstack-swift-container, openstack-swift-object, xfsprogs, rsync]:
           ensure => purged,
           require => Exec["storage-uninit.sh", "rsync"];
    }

    file {
       "/tmp/swift/storage-uninit.sh":
           source => "puppet:///modules/swift_centos/storage-uninit.sh"
    }

    exec {
        "/tmp/swift/storage-uninit.sh $storage_path $storage_dev 2>&1":
            alias => "storage-uninit.sh",
            require => File["/tmp/swift/storage-uninit.sh"];

        "killall rsync; exit 0":
            alias => "rsync";
    }
}
