class keystone_centos::keystone::uninstall {
    package {
        [openstack-utils, openstack-keystone, python-keystoneclient]:
            ensure => purged;
    }

    exec {
        "rm -rf /etc/keystone; rm -rf /var/lib/keystone; rm -rf /var/log/keystone":
            require => Package[openstack-utils, openstack-keystone, python-keystoneclient];
    }
}
