class glance_e::glance::install {
    package {
        [glance, glance-api, glance-client, glance-common, glance-registry, python-glance, python-keystone, python-swift]:
    }

    file {
        "/etc/glance/glance-api.conf":
            content => template("$proposal_id/etc/glance/glance-api.conf.erb"),
            mode => 644,
            alias => "glance-api",
            require => Package[glance];

        "/etc/glance/glance-registry.conf":
            content => template("$proposal_id/etc/glance/glance-registry.conf.erb"),
            mode => 644,
            alias => "glance-registry",
            require => Package[glance];

        "/etc/glance/glance-api-paste.ini":
            content => template("$proposal_id/etc/glance/glance-api-paste.ini.erb"),
            mode => 644,
            alias => "glance-api-paste",
            require => Package[glance];

        "/etc/glance/glance-registry-paste.ini":
            content => template("$proposal_id/etc/glance/glance-registry-paste.ini.erb"),
            mode => 644,
            alias => "glance-registry-paste",
            require => Package[glance];
    }

    exec {
        "stop glance-api; stop glance-registry; start glance-api; start glance-registry":
             require => [File["glance-api", "glance-registry", "glance-api-paste", "glance-registry-paste"], Package[python-swift]];
    }
}
