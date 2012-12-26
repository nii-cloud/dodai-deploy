class nova_and_quantum_f_centos::nova_cert::install {
    include nova_and_quantum_f_centos::common::install

    service {
        openstack-nova-cert:
            ensure => running,
            require => Package[openstack-nova];
    }
}
