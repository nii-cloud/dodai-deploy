class nova_and_quantum_f::cinder_scheduler::uninstall {
    include nova_and_quantum_f::cinder_common::uninstall

    package {
        cinder-scheduler:
            ensure => purged;
    }
}
