class nova_centos::open_iscsi::uninstall {
    package {
        iscsi-initiator-utils:
            ensure => purged
    }
}
