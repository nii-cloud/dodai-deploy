class nova_and_quantum_f::cinder_volume::install {
    include nova_and_quantum_f::cinder_common::install

    package {
        [cinder-volume, lvm2, tgt]:
            require => Package[cinder-common];
    }

    file {
        "/etc/tgt/conf.d/cinder_tgt.conf":
            content => template("$proposal_id/etc/tgt/conf.d/cinder_tgt.conf.erb"),
            mode => 644,
            alias => "cinder_tgt.conf",
            require => Package[tgt];
    }

    exec {
        "stop cinder-volume; start cinder-volume":
            require => [Package[cinder-volume, lvm2, tgt], Exec["db-sync"]];

        "stop tgt; start tgt":
            require => File["cinder_tgt.conf"];
    }
}
