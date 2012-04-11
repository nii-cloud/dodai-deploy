class nova_e::nova_api::uninstall {
    include nova_e::common::uninstall

    package {
        [nova-api, python-libvirt, euca2ools]:
            ensure => purged
    }
}
