class nova_and_quantum_f::novnc::uninstall {
    package {
        [python-numpy, nova-consoleauth, python-novnc, novnc]:
            ensure => purged
    }
}
