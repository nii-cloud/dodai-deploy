class nova_e::nova_cert::uninstall {
    include nova_e::common::uninstall

    package {
        nova-cert:
            ensure => purged
    }
}
