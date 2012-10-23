class nova_and_quantum_f::open_iscsi::uninstall {
    package {
        open-iscsi:
            ensure => purged
    }
}
