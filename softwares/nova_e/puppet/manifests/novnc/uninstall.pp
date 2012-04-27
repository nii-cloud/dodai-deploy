class nova_e::novnc::uninstall {
    package {
        [python-numpy, nova-consoleauth, python-novnc, novnc]:
            ensure => purged
    }
}
