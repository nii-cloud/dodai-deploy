class nova_and_quantum_f::open_iscsi::install {
    package {
        open-iscsi:
    }

    service {
        open-iscsi:
            ensure => running,
            require => Package[open-iscsi]
    }
}
