class nova::nova_scheduler::uninstall {
    include nova::common::uninstall

    package {
        nova-scheduler:
            ensure => purged
    }
}
