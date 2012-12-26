class nova_and_quantum_centos_f::nova_scheduler::install {
    include nova_and_quantum_centos_f::common::install

    service {
        openstack-nova-scheduler:
            ensure => running,
            require => File["/etc/nova/nova.conf"];
    }
}
