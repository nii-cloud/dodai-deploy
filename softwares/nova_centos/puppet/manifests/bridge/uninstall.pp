class nova_centos::bridge::uninstall {
    package {
        bridge-utils:
          ensure => purged
    }
}
