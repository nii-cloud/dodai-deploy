class glance_f_centos::glance::install {
    package {
        [openstack-utils, openstack-glance]:
    }

    file {
        "/etc/glance/glance-api.conf":
            content => template("$proposal_id/etc/glance/glance-api.conf.erb"),
            mode => 644,
            alias => "glance-api",
            require => Package[openstack-utils, openstack-glance];

        "/etc/glance/glance-registry.conf":
            content => template("$proposal_id/etc/glance/glance-registry.conf.erb"),
            mode => 644,
            alias => "glance-registry",
            require => Package[openstack-utils, openstack-glance];    
    }

    exec {
        "service openstack-glance-api start; service openstack-glance-registry start; glance-manage db_sync":
             require => Exec["mysql-init.sh"];

        "openstack-db --init --service glance -r nova 2>&1":
            alias => "mysql-init.sh",
            require => File["glance-api", "glance-registry"];
    }
}
