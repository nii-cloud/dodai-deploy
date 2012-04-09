class keystone_e::keystone::install {
    package {
        [keystone, python-keystone, python-keystoneclient]:
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
            source => "puppet:///modules/keystone_e/keystone-init.sh",
            require => Exec[restart_keystone];
    }

    exec {
        "stop keystone; start keystone; sleep 5":
            alias => "restart_keystone",
            require => File["keystone", "default_catalog"];

        "/var/lib/keystone/keystone-init.sh $admin_password $admin_token $service_password":
            require => File["/var/lib/keystone/keystone-init.sh"];
    }
}
