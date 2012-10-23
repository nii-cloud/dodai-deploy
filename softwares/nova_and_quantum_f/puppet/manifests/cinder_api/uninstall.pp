class nova_and_quantum_f::cinder_api::uninstall {
    include nova_and_quantum_f::cinder_common::uninstall

    package {
        cinder-api:
            ensure => purged,
    }
}
