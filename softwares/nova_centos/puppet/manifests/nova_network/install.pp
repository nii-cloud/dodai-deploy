class nova_centos::nova_network::install {
    package { [radvd, dnsmasq, dnsmasq-utils, iptables]: }

    service {
        dnsmasq:
            ensure => stopped,
            require => Package[dnsmasq];

        openstack-nova-network:
            ensure => running,
            require => [Package[iptables, radvd, bridge-utils], Service[dnsmasq], File["/etc/nova/nova.conf"]];
    }

    include nova_centos::bridge::install

}
