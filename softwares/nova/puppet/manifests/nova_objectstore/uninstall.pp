class nova::nova_objectstore::uninstall {
    include nova::common::uninstall

    package {
        nova-objectstore:
            ensure => purged
    }
}
