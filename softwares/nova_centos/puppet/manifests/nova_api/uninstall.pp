class nova_centos::nova_api::uninstall {
    include nova_centos::common::uninstall

    package {
        euca2ools:
            ensure => purged;
    }
}
