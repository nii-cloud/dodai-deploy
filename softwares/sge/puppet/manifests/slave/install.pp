class sge::slave::install {
    include sge::common::install

    file {
        "/tmp/sge/slave-preseed.conf":
            alias => "slave-preseed",
            content => template("sge/slave-preseed.conf.erb"),
            require => File["/tmp/sge"];

        "/etc/gridengine/bootstrap":
            content => template("$proposal_id/etc/gridengine/bootstrap.erb"),
            mode => 644,
            alias => bootstrap,
            require => Package[gridengine-client, gridengine-exec];

        "/etc/gridengine/configuration":
            content => template("$proposal_id/etc/gridengine/configuration.erb"),
            mode => 644,
            alias => configuration,
            require => File[bootstrap];
    }

    package {
        [gridengine-client, gridengine-exec]:
            responsefile => "/tmp/sge/slave-preseed.conf",
            require => File["slave-preseed"];
    }
}
