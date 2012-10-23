class nova_and_quantum_f::xen::uninstall {
    package {
        nova-compute-xen:
            ensure => purged
    }
}
