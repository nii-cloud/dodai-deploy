class glance_centos_f::glance::uninstall {
    package {
        [openstack-glance, python-glance]:
            ensure => purged;
    }

    exec {
        "rm -rf /var/lib/glance; rm -rf /etc/glance; rm -rf /var/log/glance":
            require => Package[openstack-glance, python-glance]
    }
}
