class nova_and_quantum_f::dashboard::install {
    package {
        [apache2, memcached, libapache2-mod-wsgi, openstack-dashboard, lessc]:
    }

    file {
        "/etc/apache2/conf.d/openstack-dashboard.conf":
            content => template("$proposal_id/etc/apache2/conf.d/openstack-dashboard.conf.erb"),
            mode => 644,
            alias => "dashboard.conf",
            require => Package[apache2, openstack-dashboard];

        "/etc/openstack-dashboard/local_settings.py":
            content => template("$proposal_id/etc/openstack-dashboard/local_settings.py.erb"),
            mode => 644,
            alias => "local_settings.py",
            require => Package[openstack-dashboard];
    }

    exec {
        "/etc/init.d/apache2 stop; /etc/init.d/apache2 start":
            require => File["dashboard.conf", "local_settings.py"];
    }
}
