class nova_e::novnc::uninstall {
    include nova_e::common::uninstall

    package {
        [python-numpy, nova-consoleauth]:
            ensure => purged
    }

    exec {
        "stop novnc; rm /etc/init/novnc.conf; rm -rf /var/lib/novnc*":
    }
}
