class nova::dashboard_r46::install {
    $dashboard_home = "/var/opt/osdb/openstack-dashboard"

    package {
        [bzr, python-virtualenv]:
    }

    file {
        "/var/opt/dashboard-install.sh":
            alias => "dashboard-install",
            source => "puppet:///modules/nova/dashboard-install.sh",
            require => Package[bzr, python-virtualenv];

        "$dashboard_home/dashboard-init.sh":
            alias => "dashboard-init",
            source => "puppet:///modules/nova/dashboard-init.sh",
            require => Exec["dashboard-install"];

        "$dashboard_home/local/local_settings.py":
            content => template("$proposal_id/local_settings.py.erb"),
            alias => local_settings,
            require => Exec["dashboard-install"];

        "/etc/init/openstack-dashboard.conf":
            content => template("nova/openstack-dashboard.conf.erb"),
            mode => 644,
            alias => "openstack-dashboard";

        "$dashboard_home/tools/with_venv.sh":
            alias => with_venv,
            source => "puppet:///modules/nova/with_venv.sh",
            require => Exec["dashboard-install"];

        "$dashboard_home/dashboard/change_password.py":
            alias => change_password,
            source => "puppet:///modules/nova/change_password.py",
            require => Exec["dashboard-install"];
    }

    exec {
        "/var/opt/dashboard-install.sh 2>&1":
            require => File["dashboard-install"],
            timeout => 1800,
            alias => "dashboard-install";

        "$dashboard_home/dashboard-init.sh $project $user $password $email 2>&1":
            alias => "dashboard-init",
            require => File["dashboard-init", local_settings, "openstack-dashboard", with_venv, change_password],
            notify => Service["openstack-dashboard"];
    }
    service {
        openstack-dashboard:
            ensure => running,
            start => "start openstack-dashboard",
            stop => "stop openstack-dashboard; exit 0",
            status => "status openstack-dashboard";
    }
}
