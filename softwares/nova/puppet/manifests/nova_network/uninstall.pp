class nova::nova_network::uninstall {
    include nova::common::uninstall

    package {
        [nova-network, dnsmasq]:
            ensure => purged
    }

    exec {
        "killall dnsmasq; exit 0":
            require => Package[dnsmasq]
    }
}
