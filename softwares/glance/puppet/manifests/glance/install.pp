class glance::glance::install {
    package {
        [glance, python-swift]:
            require => Package[python-httplib2];

        python-httplib2:
    }

    file {
        "/etc/glance/glance-api.conf":
            content => template("$proposal_id/etc/glance/glance-api.conf.erb"),
            mode => 644,
            alias => "glance-api",
            require => Package[glance, python-swift];

        "/etc/glance/glance-registry.conf":
            content => template("$proposal_id/etc/glance/glance-registry.conf.erb"),
            mode => 644,
            alias => "glance-registry",
            require => Package[glance, python-swift];
    }

    exec {
        "stop glance-api; stop glance-registry; start glance-api; start glance-registry":
             require => File["glance-api", "glance-registry"];
    }
}
