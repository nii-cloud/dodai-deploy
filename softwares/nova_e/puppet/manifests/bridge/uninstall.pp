class nova_e::bridge::uninstall {
    package {
        bridge-utils:
          ensure => purged
    }
}
