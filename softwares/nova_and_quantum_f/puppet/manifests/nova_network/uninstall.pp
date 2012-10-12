class nova_and_quantum_f::nova_network::uninstall {
    include nova_and_quantum_f::common::uninstall
    include nova_and_quantum_f::bridge::uninstall

    package {
        [nova-network, dnsmasq]:
            ensure => purged
    }

    exec {
        "killall dnsmasq; exit 0":
            require => Package[dnsmasq];
    }

    include nova_and_quantum_f::linuxbridge_agent::uninstall

    package {
        [quantum-dhcp-agent, quantum-l3-agent]:
            ensure => purged;
    }
}
