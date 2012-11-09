class nova_centos::nova_api::install {

    include nova_centos::common::install

    package {
        euca2ools:
            require => Package[openstack-nova];
    }

    file {
        "/var/lib/nova/nova-init.sh":
            source => "puppet:///modules/nova_centos/nova-init.sh",
            alias => "nova-init.sh", 
            require => Package[openstack-nova];
    }

    exec {
        "/var/lib/nova/nova-init.sh $network_ip_range 2>&1":
            alias => "nova-init.sh",
            require => File["nova-init.sh", "/etc/nova/nova.conf"];
    }

    service {
        openstack-nova-api:
            ensure => running,
            require => Exec["nova-init.sh"];
    }
}
