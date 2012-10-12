class nova_and_quantum_f::nova_scheduler::uninstall {
    include nova_and_quantum_f::common::uninstall

    package {
        nova-scheduler:
            ensure => purged
    }
}
