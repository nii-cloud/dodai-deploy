class nova_and_quantum_centos_f::nova_cert::install {
    include nova_and_quantum_centos_f::common::install

    service {
        openstack-nova-cert:
            ensure => running,
            require => Package[openstack-nova];
    }
}
