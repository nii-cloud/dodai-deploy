class keystone_centos::keystone::install {
    package {
        [openstack-utils, openstack-keystone, python-keystoneclient]:
            require => Exec["rpm"];
    }

    file {
        "/tmp/epel-release-6-7.noarch.rpm":
            source => "puppet:///modules/keystone_centos/epel-release-6-7.noarch.rpm",
            mode => 644;

        "/etc/keystone/keystone.conf":
            content => template("$proposal_id/etc/keystone/keystone.conf.erb"),
            mode => 644,
            alias => "keystone",
            require => Package[[openstack-utils, openstack-keystone, python-keystoneclient]];

        "/etc/keystone/default_catalog.templates":
            content => template("$proposal_id/etc/keystone/default_catalog.templates.erb"),
            mode => 644,
            alias => "default_catalog",
            require => Package[[openstack-utils, openstack-keystone, python-keystoneclient]];
            
        "/var/lib/keystone/keystone-init.sh":
            content => template("keystone_centos/keystone-init.sh.erb"),
            require => Exec["start_keystone"];
    }

    exec {
        "rpm -U --replacepkgs /tmp/epel-release-6-7.noarch.rpm":
            alias => "rpm",
            require => File["/tmp/epel-release-6-7.noarch.rpm"];

        "service openstack-keystone start; chkconfig openstack-keystone on; keystone-manage db_sync":
            alias => "start_keystone",
            require => File["keystone", "default_catalog"];

        "chmod 666 /var/lib/keystone/keystone.db":
            alias => "chmod",
            require => Exec["start_keystone"];

        "/var/lib/keystone/keystone-init.sh":
            require => [Exec["chmod"], File["/var/lib/keystone/keystone-init.sh"]];

    }
}
