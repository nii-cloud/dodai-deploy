class nova_and_quantum_f::common::uninstall {
    package {
        [python-nova, nova-common]:
           ensure => purged
    }
}
