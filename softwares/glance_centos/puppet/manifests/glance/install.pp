class glance_centos::glance::install {
    package {
        [openstack-glance]:
    }

    file {
        "/etc/glance/glance-api.conf":
            content => template("$proposal_id/etc/glance/glance-api.conf.erb"),
            mode => 644,
            alias => "glance-api",
            require => Package[openstack-glance];

        "/etc/glance/glance-registry.conf":
            content => template("$proposal_id/etc/glance/glance-registry.conf.erb"),
            mode => 644,
            alias => "glance-registry",
            require => Package[openstack-glance];

        "/etc/glance/glance-api-paste.ini":
            content => template("$proposal_id/etc/glance/glance-api-paste.ini.erb"),
            mode => 644,
            alias => "glance-api-paste",
            require => Package[openstack-glance];

        "/etc/glance/glance-registry-paste.ini":
            content => template("$proposal_id/etc/glance/glance-registry-paste.ini.erb"),
            mode => 644,
            alias => "glance-registry-paste",
            require => Package[openstack-glance];
    }

    exec {
        "service openstack-glance-api start; service openstack-glance-registry start":
             require => File["glance-api", "glance-registry", "glance-api-paste", "glance-registry-paste"];
    }
}
