class nova_and_quantum_centos_f::cinder_volume::install{
    include nova_and_quantum_centos_f::cinder_common::install

   file {
        "/etc/tgt/conf.d/cinder.conf":
            content => template("$proposal_id/etc/tgt/conf.d/cinder_tgt.conf.erb"),
            mode => 644,
            alias => "cinder_tgt.conf",
            require => Exec["db-sync"];

        "/etc/tgt/targets.conf":
            content => template("$proposal_id/etc/tgt/targets.conf.erb"),
            mode => 644,
            alias => "targets.conf",
            require => Exec["db-sync"];
    }

    exec {
        "service openstack-cinder-volume start":
            require => File["cinder_tgt.conf","targets.conf"];
        
        "service tgtd restart":
            require => File["cinder_tgt.conf","targets.conf"];
    }
}
