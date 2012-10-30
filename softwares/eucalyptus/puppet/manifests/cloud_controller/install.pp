class eucalyptus::cloud_controller::install {
    include eucalyptus::common::install

    package {
        [eucalyptus-cloud, eucalyptus-walrus]:
            responsefile => "/tmp/postfix_preseed.conf",
            require => [File["postfix_preseed"], Apt::Key["C1240596"], Apt::Sources_list["euca2ools", "eucalyptus"]];
    }

    file {
        "/tmp/postfix_preseed.conf":
            source => "puppet:///modules/eucalyptus/postfix_preseed.conf",
            mode => 644,
            alias => "postfix_preseed";

        "/etc/eucalyptus/eucalyptus.conf":
            content => template("$proposal_id/etc/eucalyptus/eucalyptus_clc.conf.erb"),
            mode => 644,
            alias => "conf",
            require => Package[eucalyptus-cloud, eucalyptus-walrus];

        "/var/lib/eucalyptus/register.sh":
            content => template("eucalyptus/register.sh.erb"),
            require => Package[eucalyptus-cloud, eucalyptus-walrus];
    }

    exec {
        "euca_conf --initialize":
            alias => "initialize",
            require => File["conf"];

        "/var/lib/eucalyptus/register.sh":
            require => [File["/var/lib/eucalyptus/register.sh"], Service[eucalyptus-cloud]];
    }

    service {
        eucalyptus-cloud:
            ensure => running,
            require => Exec["initialize"];
    }
}

