class nova_centos::nova_volume::install {
    include nova_centos::common::install
    
    service {
        openstack-nova-volume:
            ensure => running,
            require => File["/etc/nova/nova.conf"];
    }
}
