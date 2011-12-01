class nova::dashboard_r46::uninstall {
    service {
        openstack-dashboard:
            ensure => stopped,
            start => "start openstack-dashboard",
            stop => "stop openstack-dashboard; exit 0",
            status => "status openstack-dashboard";
    }

    file {
        ["/etc/init/openstack-dashboard.conf", "/var/opt/dashboard-install.sh"]:
            ensure => absent,
            require => Service[openstack-dashboard];
    }

    exec {
        "rm -rf /var/opt/osdb; exit 0":
            require => Service[openstack-dashboard];
    }
}
