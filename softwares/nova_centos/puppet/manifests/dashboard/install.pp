class nova_centos::dashboard::install {
    package {
        [httpd, memcached, mod_wsgi, openstack-dashboard]:
    }

    file {
        "/etc/httpd/conf.d/openstack-dashboard.conf":
            content => template("$proposal_id/etc/httpd/conf.d/openstack-dashboard.conf.erb"),
            mode => 644,
            alias => "dashboard.conf",
            require => Package[httpd, openstack-dashboard];

        "/etc/openstack-dashboard/local_settings":
            content => template("$proposal_id/etc/openstack-dashboard/local_settings.erb"),
            mode => 644,
            alias => "local_settings",
            require => Package[openstack-dashboard];
    }

    exec {
        "service httpd restart":
            require => File["dashboard.conf", "local_settings"];
    }

    service {
        memcached:
            ensure => running,
            require => Package[memcached];
    }
}
