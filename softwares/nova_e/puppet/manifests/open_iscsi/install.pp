class nova_e::open_iscsi::install {
    package {
        open-iscsi:
    }

    service {
        open-iscsi:
            ensure => running,
            require => Package[open-iscsi]
    }
}
