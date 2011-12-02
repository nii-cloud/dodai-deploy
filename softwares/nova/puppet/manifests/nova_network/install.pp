class nova::nova_network::install {
    nova::component { "nova-network": }

    package { [radvd, dnsmasq, iptables]: }

    service {
        dnsmasq:
            ensure => stopped,
            require => Package[dnsmasq]
    }

    include nova::bridge

    exec {
        "stop nova-network; start nova-network":
            require => [Package[nova-network, iptables, radvd, bridge-utils], Service[dnsmasq]]
    }
}
