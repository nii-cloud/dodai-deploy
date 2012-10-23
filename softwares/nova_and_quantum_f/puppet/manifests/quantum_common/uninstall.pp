class nova_and_quantum_f::quantum_common::uninstall {
    package {
        [quantum-common, quantum-plugin-linuxbridge, python-quantum, python-quantumclient]:
            ensure => purged,
    }

    exec {
        "rm -rf /var/lib/quantum/*":
            require => Package[quantum-common, quantum-plugin-linuxbridge, python-quantum, python-quantumclient];
    }
}
