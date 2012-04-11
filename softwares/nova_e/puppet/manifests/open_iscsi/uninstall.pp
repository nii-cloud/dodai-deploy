class nova_e::open_iscsi::uninstall {
    package {
        open-iscsi:
            ensure => purged
    }
}
