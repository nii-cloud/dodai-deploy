class glance::glance::uninstall {
    package {
        glance:
            ensure => purged;
    }

    exec {
        "rm -rf /var/lib/glance/*":
            require => Package[glance]
    }
}
