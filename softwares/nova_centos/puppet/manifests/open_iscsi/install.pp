class nova_centos::open_iscsi::install {
    package {
        iscsi-initiator-utils:
    }

    service {
        iscsid:
            ensure => running,
            require => Package[iscsi-initiator-utils]
    }
}
