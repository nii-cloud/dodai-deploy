class nova_and_quantum_f::nova_api::uninstall {
    include nova_and_quantum_f::common::uninstall

    package {
        [nova-api, python-libvirt, euca2ools]:
            ensure => purged
    }
}
