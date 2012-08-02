class eucalyptus::node_controller::install {
    include eucalyptus::common::install

    package {
        eucalyptus-nc:
            require => [Apt::Key[C1240596], Apt::Sources_list[euca2ools, eucalyptus]];
    }

    file {
        "/etc/eucalyptus/eucalyptus.conf":
            content => template("$proposal_id/etc/eucalyptus/eucalyptus_nc.conf.erb"),
            mode => 644,
            alias => "conf",
            require => Package[eucalyptus-nc];
    }

    service {
        eucalyptus-nc:
            ensure => running,
            require => File["conf"];
    }

}

