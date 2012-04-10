class glance_e::glance::uninstall {
    package {
        [glance, glance-api, glance-registry, glance-common]:
            ensure => purged;
    }

    exec {
        "rm -rf /var/lib/glance/*":
            require => Package[glance, glance-api, glance-registry, glance-common]
    }
}
