class nova_and_quantum_f_centos::nova_scheduler::install {
    include nova_and_quantum_f_centos::common::install

    service {
        openstack-nova-scheduler:
            ensure => running,
            require => File["/etc/nova/nova.conf"];
    }
}
