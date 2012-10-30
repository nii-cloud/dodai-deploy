class eucalyptus::cluster_controller::install {
    include eucalyptus::common::install

    package{
        [eucalyptus-cc, eucalyptus-sc]:
            require => [Apt::Key[C1240596], Apt::Sources_list[euca2ools, eucalyptus]];
    }

    file {
        "/etc/eucalyptus/eucalyptus.conf":
            content => template("$proposal_id/etc/eucalyptus/eucalyptus_cc.conf.erb"),
            mode => 644,
            alias => "conf",
            require => Package[eucalyptus-cc, eucalyptus-sc];
    }

    service {
        eucalyptus-cc:
            ensure => running,
            require => File["conf"];
    }
}

