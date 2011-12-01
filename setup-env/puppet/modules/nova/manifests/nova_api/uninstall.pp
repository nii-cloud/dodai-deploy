class nova::nova_api::uninstall {
    include nova::common::uninstall

    package {
        [nova-api, python-libvirt, euca2ools]:
            ensure => purged
    }
}
