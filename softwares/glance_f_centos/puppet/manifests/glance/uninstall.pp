class glance_f_centos::glance::uninstall {
    package {
        [openstack-glance, python-glance]:
            ensure => purged;
    }

    exec {
        "rm -rf /var/lib/glance; rm -rf /etc/glance; rm -rf /var/log/glance":
            require => Package[openstack-glance, python-glance]
    }
}
