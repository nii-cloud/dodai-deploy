class eucalyptus::node_controller::install {
    include eucalyptus::common::install

    package {
        eucalyptus-nc:
            require => [Apt::Key[C1240596], Apt::Sources_list[euca2ools, eucalyptus]];
    }

    file {
        "/tmp/add_bridge.rb":
            source => "puppet:///modules/eucalyptus/add_bridge.rb",
            mode => 644;

        "/etc/eucalyptus/eucalyptus.conf":
            content => template("$proposal_id/etc/eucalyptus/eucalyptus_nc.conf.erb"),
            mode => 644,
            alias => "conf",
            require => Package[eucalyptus-nc];
    }

    exec {
        "ruby /tmp/add_bridge.rb $nc_vnet_pubinterface $nc_vnet_bridge":
            alias => "add_bridge",
            require => [Exec["cp"], File["/tmp/add_bridge.rb"]];

        "ifdown $nc_vnet_pubinterface; ifup $nc_vnet_pubinterface; ifup $nc_vnet_bridge":
            alias => "networking",
            require => Exec["add_bridge"];

        "cp /etc/network/interfaces /etc/network/interfaces_org":
            alias => "cp";
    }

    service {
        eucalyptus-nc:
            ensure => running,
            require => [Exec["networking"], File["conf"]];
    }

}

