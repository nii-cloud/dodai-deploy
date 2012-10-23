class nova_and_quantum_f::bridge::uninstall {
    package {
        bridge-utils:
          ensure => purged
    }
}
