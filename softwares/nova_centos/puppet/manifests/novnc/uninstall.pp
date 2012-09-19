class nova_centos::novnc::uninstall {
    include nova_centos::common::uninstall

    package {
        [openstack-nova-novncproxy, novnc]:
            ensure => purged,
            require => Service[openstack-nova-novncproxy];
    }

    service {
        openstack-nova-novncproxy:
            ensure => stopped;
    }
}
