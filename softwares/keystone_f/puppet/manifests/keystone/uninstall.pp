class keystone_f::keystone::uninstall {
    package {
        [keystone, python-keystone, python-keystoneclient]:
            ensure => purged;
    }

    exec {
        "rm -rf /var/lib/keystone/*":
            require => Package[keystone]
    }
}
