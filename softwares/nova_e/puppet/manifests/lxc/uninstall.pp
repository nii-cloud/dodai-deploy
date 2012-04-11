class nova_e::lxc::uninstall {
    package {
        nova-compute-lxc:
            ensure => purged
    }
}
