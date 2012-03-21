class nova::nova_network::uninstall {
    include nova::common::uninstall

    package {
        [nova-network, dnsmasq]:
            ensure => purged
    }

    exec {
        "sysctl -w net.ipv4.ip_forward=0; killall dnsmasq; exit 0":
            require => Package[dnsmasq]
    }
}
