class nova_e::xen::uninstall {
    package {
        nova-compute-xen:
            ensure => purged
    }
}
