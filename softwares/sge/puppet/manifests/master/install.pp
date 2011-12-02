class sge::master::install {
    include sge::common::install

    file {
        "/tmp/sge/master-preseed.conf":
            alias => "master-preseed",
            content => template("sge/master-preseed.conf.erb"),
            require => File["/tmp/sge"];

        "/tmp/sge/master-init.sh":
            alias => "master-init",
            source => "puppet:///modules/sge/master-init.sh",
            require => File["/tmp/sge"];

        "/tmp/sge/allhosts-group.conf":
            alias => "allhosts-group",
            source => "puppet:///modules/sge/allhosts-group.conf",
            require => File["/tmp/sge"];

        "/tmp/sge/slave-servers":
            alias => "slave-servers",
            content => template("sge/slave-servers.erb"),
            require => File["/tmp/sge"];

        "/etc/gridengine/bootstrap":
            content => template("$proposal_id/etc/gridengine/bootstrap.erb"),
            mode => 644,
            alias => bootstrap,
            require => Package[gridengine-client, gridengine-common, gridengine-master, gridengine-qmon];

        "/etc/gridengine/configuration":
            content => template("$proposal_id/etc/gridengine/configuration.erb"),
            mode => 644,
            alias => configuration,
            require => File[bootstrap];
    }

    package {
        [gridengine-client, gridengine-common, gridengine-master, gridengine-qmon]:
            responsefile => "/tmp/sge/master-preseed.conf",
            require => [Exec["alternatives-java"], File["master-preseed"]]
    }

    exec {
        "/tmp/sge/master-init.sh 2>&1":
            alias => "master-init",
            require => [Package[gridengine-client, gridengine-common, gridengine-master, gridengine-qmon], File["slave-servers", "master-init", "allhosts-group"]];
    }
}
