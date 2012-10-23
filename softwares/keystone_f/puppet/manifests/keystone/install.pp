class keystone_f::keystone::install {
    package {
        [keystone, python-keystone, python-keystoneclient]:
            #require => [Apt::Key["EC4926EA"], Apt::Sources_list[folsom]];
            require => Exec[apt-get_update];
    }

    file {
        "/etc/keystone/keystone.conf":
            content => template("$proposal_id/etc/keystone/keystone.conf.erb"),
            mode => 644,
            alias => "keystone",
            require => Package[keystone, python-keystone];

        "/etc/keystone/default_catalog.templates":
            content => template("$proposal_id/etc/keystone/default_catalog.templates.erb"),
            mode => 644,
            alias => "default_catalog",
            require => Package[keystone, python-keystone];

        "/var/lib/keystone/keystone-init.sh":
            content => template("keystone_f/keystone-init.sh.erb"),
            require => Exec[restart_keystone];
    }

    exec {
        "stop keystone; start keystone; sleep 5":
            alias => "restart_keystone",
            require => File["keystone", "default_catalog"];

        "/var/lib/keystone/keystone-init.sh":
            require => File["/var/lib/keystone/keystone-init.sh"];
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
