class nova_and_quantum_centos_f::nova_objectstore::install {
    include nova_and_quantum_centos_f::common::install

    service {
        openstack-nova-objectstore:
            ensure => running,
            require => File["/etc/nova/nova.conf"];
    }
}
