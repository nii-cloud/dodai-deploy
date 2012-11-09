class glance_centos::glance::uninstall {
    package {
        [openstack-glance, openstack-utils, python-glance]:
            ensure => purged;
    }

    exec {
        "rm -rf /var/lib/glance; rm -rf /etc/glance; rm -rf /var/log/glance":
            require => Package[openstack-glance, openstack-utils, python-glance]
    }
}
