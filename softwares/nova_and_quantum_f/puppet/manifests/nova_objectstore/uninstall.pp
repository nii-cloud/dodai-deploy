class nova_and_quantum_f::nova_objectstore::uninstall {
    include nova_and_quantum_f::common::uninstall

    package {
        nova-objectstore:
            ensure => purged
    }
}
