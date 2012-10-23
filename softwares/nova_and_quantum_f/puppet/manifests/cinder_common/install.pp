class nova_and_quantum_f::cinder_common::install {
    include nova_and_quantum_f::common::add_source_list
    package {
        cinder-common:
            require => Exec[apt-get_update];
    }

    file {
        "/etc/cinder/cinder.conf":
            content => template("$proposal_id/etc/cinder/cinder.conf.erb"),
            mode => 644,
            alias => "cinder.conf",
            require => Package[cinder-common];

        "/etc/cinder/api-paste.ini":
            content => template("$proposal_id/etc/cinder/api-paste-cinder.ini.erb"),
            mode => 644,
            alias => "api-paste.ini",
            require => Package[cinder-common];
    }

    exec {
        "cinder-manage db sync":
            alias => "db-sync",
            require => File["cinder.conf", "api-paste.ini"];
    }
}
