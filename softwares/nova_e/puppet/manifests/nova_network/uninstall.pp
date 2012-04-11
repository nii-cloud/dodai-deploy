class nova_e::nova_network::uninstall {
    include nova_e::common::uninstall
    include nova_e::bridge::uninstall

    package {
        [nova-network, dnsmasq]:
            ensure => purged
    }

    exec {
        "killall dnsmasq; exit 0":
            require => Package[dnsmasq]
    }
}
