class nova_centos::nova_scheduler::install {
    include nova_centos::common::install

    service {
        openstack-nova-scheduler:
            ensure => running,
            require => File["/etc/nova/nova.conf"];
    }
}
