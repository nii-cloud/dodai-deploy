class nova_and_quantum_f::linuxbridge_agent::uninstall {

    include nova_and_quantum_f::quantum_common::uninstall

    package {
        quantum-plugin-linuxbridge-agent:
            ensure => purged;
    }
}
