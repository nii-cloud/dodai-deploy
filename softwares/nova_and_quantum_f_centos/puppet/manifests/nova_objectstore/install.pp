class nova_and_quantum_f_centos::nova_objectstore::install {
    include nova_and_quantum_f_centos::common::install

    service {
        openstack-nova-objectstore:
            ensure => running,
            require => File["/etc/nova/nova.conf"];
    }
}
