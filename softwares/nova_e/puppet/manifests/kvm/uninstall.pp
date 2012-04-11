class nova_e::kvm::uninstall {
    package {
        nova-compute-kvm:
            ensure => purged
    }
}
