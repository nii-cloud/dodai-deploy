class nova_centos::nova_network::uninstall {
    include nova_centos::common::uninstall
    include nova_centos::bridge::uninstall

    package {
        dnsmasq:
            ensure => purged
    }

    exec {
        "killall dnsmasq; exit 0":
            require => Package[dnsmasq];
    }
}
