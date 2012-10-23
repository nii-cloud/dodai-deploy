class nova_and_quantum_f::nova_volume::uninstall {
    include nova_and_quantum_f::common::uninstall

    package {
        nova-volume:
            ensure => purged
    }

    include nova_and_quantum_f::tgt::uninstall
}
