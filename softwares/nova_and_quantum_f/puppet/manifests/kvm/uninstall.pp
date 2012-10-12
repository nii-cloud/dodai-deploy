class nova_and_quantum_f::kvm::uninstall {
    package {
        nova-compute-kvm:
            ensure => purged
    }
}
