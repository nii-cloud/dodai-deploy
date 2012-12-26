class nova_and_quantum_centos_f::dashboard::uninstall {
    package {
        openstack-dashboard:
            ensure => purged;
    }

    exec {
        "rm -rf /var/lib/openstack-dashboard; rm -rf /etc/openstack-dashboard":
            require => Package[openstack-dashboard];
    }
}
