class nova_e::nova_scheduler::uninstall {
    include nova_e::common::uninstall

    package {
        nova-scheduler:
            ensure => purged
    }
}
