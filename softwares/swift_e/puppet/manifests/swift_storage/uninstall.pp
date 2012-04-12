class swift_e::swift_storage::uninstall {
    package {
        [swift-account, swift-container, swift-object, xfsprogs, rsync]:
           ensure => purged,
           require => Exec["storage-uninit.sh"]
    }

    file {
       "/tmp/swift/storage-uninit.sh":
           source => "puppet:///modules/swift/storage-uninit.sh"
    }

    exec {
        "/tmp/swift/storage-uninit.sh $storage_path $storage_dev 2>&1":
            alias => "storage-uninit.sh",
            require => File["/tmp/swift/storage-uninit.sh"]
    }
}
