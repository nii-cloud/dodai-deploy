class nova_e::nova_network::install {
    nova_e::component { "nova-network": }

    package { [radvd, dnsmasq, iptables]: }

    service {
        dnsmasq:
            ensure => stopped,
            require => Package[dnsmasq]
    }

    include nova_e::bridge::install

    exec {
        "stop nova-network; start nova-network":
            require => [Package[nova-network, iptables, radvd, bridge-utils], Service[dnsmasq], File["/etc/nova/nova.conf"]]
    }
}
