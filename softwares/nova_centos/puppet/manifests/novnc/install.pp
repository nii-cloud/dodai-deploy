class nova_centos::novnc::install {
    include nova_centos::common::install

    package {
        [openstack-nova-novncproxy, novnc]:
            require => Package[openstack-nova];
    }

    service {
        [openstack-nova-novncproxy, openstack-nova-consoleauth]:
            ensure => running,
            require => Package[openstack-nova-novncproxy, novnc];
    }
}
