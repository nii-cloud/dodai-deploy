class nova_e::dashboard::uninstall {
    package {
        openstack-dashboard:
            ensure => purged;
    }
}
