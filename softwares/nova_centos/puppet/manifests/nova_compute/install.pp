class nova_centos::nova_compute::install {
    include nova_centos::common::install

    include nova_centos::bridge::install
    include nova_centos::open_iscsi::install

    service {
        libvirtd:
            ensure => running,
            require => Package[openstack-nova];

        openstack-nova-compute:
            ensure => running,
            require => [Service[libvirtd], File["/etc/nova/nova.conf"]];

        openstack-nova-metadata-api:
            ensure => running,
            require => [Service[libvirtd], File["/etc/nova/nova.conf"]];
    }
}
