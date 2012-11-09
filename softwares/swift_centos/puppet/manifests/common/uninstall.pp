class swift_centos::common::uninstall {
    package {
        openstack-swift:
            ensure => purged;
    }
}
