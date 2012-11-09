class nova_centos::nova_objectstore::install {
    include nova_centos::common::install

    service {
        openstack-nova-objectstore:
            ensure => running,
            require => File["/etc/nova/nova.conf"];
    }
}
