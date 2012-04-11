class nova_e::common::uninstall {
    package {
        [python-nova, nova-common]:
           ensure => purged
    }
}
