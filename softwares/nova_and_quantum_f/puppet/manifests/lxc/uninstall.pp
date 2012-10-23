class nova_and_quantum_f::lxc::uninstall {
    package {
        nova-compute-lxc:
            ensure => purged
    }
}
