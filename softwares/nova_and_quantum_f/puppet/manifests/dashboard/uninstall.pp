class nova_and_quantum_f::dashboard::uninstall {
    package {
        openstack-dashboard:
            ensure => purged;
    }
}
