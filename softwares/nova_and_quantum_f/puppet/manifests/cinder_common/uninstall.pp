class nova_and_quantum_f::cinder_common::uninstall {
    package {
        [cinder-common, python-cinder]:
            ensure => purged;
    }
}
