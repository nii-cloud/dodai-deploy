class nova_and_quantum_centos_f::cinder_common::install {
    package {
        openstack-cinder:
    }

    file {
        "/etc/cinder/cinder.conf":
            content => template("$proposal_id/etc/cinder/cinder.conf.erb"),
            mode => 644,
            alias => "cinder.conf",
            require => Package[openstack-cinder];

        "/etc/cinder/api-paste.ini":
            content => template("$proposal_id/etc/cinder/api-paste-cinder.ini.erb"),
            mode => 644,
            alias => "api-paste.ini",
            require => Package[openstack-cinder];
    }

    exec {
        "openstack-db --init --service cinder -r nova":
            alias => "cinder-create-db",
            require => File["cinder.conf", "api-paste.ini"];

        "cinder-manage db sync":
            alias => "db-sync",
            require => Exec["cinder-create-db"];
    }
}
