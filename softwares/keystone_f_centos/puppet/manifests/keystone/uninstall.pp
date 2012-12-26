class keystone_f_centos::keystone::uninstall {
    package {
        [openstack-keystone, python-keystoneclient]:
            ensure => purged;
    }

    exec {
        "rm -rf /etc/keystone; rm -rf /var/lib/keystone; rm -rf /var/log/keystone":
            require => Package[openstack-keystone, python-keystoneclient];
    }
}
