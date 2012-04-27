class nova_e::tgt::uninstall {
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
