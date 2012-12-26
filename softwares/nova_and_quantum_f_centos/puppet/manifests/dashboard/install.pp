class nova_and_quantum_centos_f::dashboard::install {
    package {
        [mod_wsgi, openstack-dashboard]:
    }

    file {

        "/var/lib/nova/dashboard-init.sh":
            source => "puppet:///modules/nova_and_quantum_centos_f/dashboard-init.sh",
            alias => "dashboard-init.sh", 
            require => Package[openstack-dashboard];
}

    exec {
        "/var/lib/nova/dashboard-init.sh 2>&1":
            alias => "dashboard-init.sh",
            require => File["dashboard-init.sh"];

        "service httpd restart":
            require => Exec["dashboard-init.sh"];

        "service openstack-nova-api restart":
            require => Exec["dashboard-init.sh"];
   
    }

}
