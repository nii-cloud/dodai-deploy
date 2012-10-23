class nova_and_quantum_f::tgt::uninstall {
    package {
        tgt:
            ensure => purged,
            require => Service[tgt]
    }

    service {
        tgt:
            ensure => stopped
    }
}
