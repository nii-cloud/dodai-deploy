class eucalyptus::node_controller::uninstall {
    include eucalyptus::common::uninstall
    package {
        eucalyptus-nc:
            ensure => purged,
            require => Exec["/tmp/nc-uninit.sh"];
    }

    file {
        "/tmp/nc-uninit.sh":
            alias => "nc-uninit.sh",
            source => "puppet:///modules/eucalyptus/nc-uninit.sh";
    }

    exec {
        "/tmp/nc-uninit.sh":
            require => File["nc-uninit.sh"];

        "ifdown $nc_vnet_bridge":
            alias => "ifdown",
            require => Package[eucalyptus-nc];

        "mv /etc/network/interfaces_org /etc/network/interfaces":
            alias => "mv",
            require => Exec["ifdown"];

        "ifdown $nc_vnet_pubinterface; ifup $nc_vnet_pubinterface":
            require => Exec["mv"];
    }
}
