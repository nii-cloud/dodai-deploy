class nova_and_quantum_f::nova_network::install {

    nova_and_quantum_f::component { "nova-network": }

    package { [radvd, dnsmasq, iptables]: }

    service {
        dnsmasq:
            ensure => stopped,
            require => Package[dnsmasq]
    }

    include nova_and_quantum_f::bridge::install

    exec {
        "stop nova-network; start nova-network":
            require => [Package[nova-network, iptables, radvd, bridge-utils], Service[dnsmasq], File["/etc/nova/nova.conf"]]
    }

    include nova_and_quantum_f::linuxbridge_agent::install

    package {
        [quantum-dhcp-agent, quantum-l3-agent]:
            require => Package[quantum-common];
    }

    file {
        "/etc/quantum/dhcp_agent.ini":
            content => template("$proposal_id/etc/quantum/dhcp_agent.ini.erb"),
            alias => "dhcp",
            mode => 644,
            require => Package[quantum-dhcp-agent];

        "/etc/quantum/l3_agent.ini":
            content => template("$proposal_id/etc/quantum/l3_agent.ini.erb"),
            alias => "l3",
            mode => 644,
            require => Package[quantum-l3-agent];
    }

    exec {
       "stop quantum-dhcp-agent; start quantum-dhcp-agent":
           require => File["dhcp"];

       "stop quantum-l3-agent; start quantum-l3-agent":
           require => File["l3"];
    }
}
