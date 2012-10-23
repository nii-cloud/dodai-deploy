class glance_f::glance::install {
    package {
        [glance, glance-api, python-glanceclient, glance-common, glance-registry, python-glance, python-keystone, python-swift]:
            require => Exec[apt-get_update];
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
    }

    exec {
        "stop glance-api; stop glance-registry; start glance-api; start glance-registry":
             require => [File["glance-api", "glance-registry"], Package[python-swift]];
    }

    include apt

    apt::key {
        "EC4926EA":
            keyserver => "keyserver.ubuntu.com",
    }

    apt::sources_list {
        folsom:
            ensure  => present,
            content => 'deb http://ubuntu-cloud.archive.canonical.com/ubuntu precise-updates/folsom main',
    }
}
