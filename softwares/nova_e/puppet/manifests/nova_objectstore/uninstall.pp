class nova_e::nova_objectstore::uninstall {
    include nova_e::common::uninstall

    package {
        nova-objectstore:
            ensure => purged
    }
}
