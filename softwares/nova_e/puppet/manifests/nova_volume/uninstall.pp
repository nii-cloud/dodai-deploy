class nova_e::nova_volume::uninstall {
    include nova_e::common::uninstall

    package {
        nova-volume:
            ensure => purged
    }

    include nova_e::tgt::uninstall
}
