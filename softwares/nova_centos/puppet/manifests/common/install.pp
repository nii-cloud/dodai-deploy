class nova_centos::common::install {
    package {
        openstack-nova:
    }

    file {
        "/etc/nova/nova.conf":
            content => template("$proposal_id/etc/nova/nova.conf.erb"),
            mode => 644,
            require => Package[openstack-nova];

        "/etc/nova/api-paste.ini":
            content => template("$proposal_id/etc/nova/api-paste.ini.erb"),
            mode => 644,
            require => Package[openstack-nova];
    }
}
