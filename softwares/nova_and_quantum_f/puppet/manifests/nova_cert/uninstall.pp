class nova_and_quantum_f::nova_cert::uninstall {
    include nova_and_quantum_f::common::uninstall

    package {
        nova-cert:
            ensure => purged
    }
}
