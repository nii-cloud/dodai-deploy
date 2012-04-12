class nova_e::nova_api::install {
    nova_e::component {
        ["nova-api", "python-libvirt", euca2ools, unzip, gawk]:
    }

    file {
        "/var/lib/nova/nova-init.sh":
            source => "puppet:///modules/nova_e/nova-init.sh",
            alias => "nova-init.sh", 
            require => Package[nova-common];
    }

    exec {
        "stop nova-api; start nova-api":
            require => Exec["nova-init.sh"];

        "/var/lib/nova/nova-init.sh $network_ip_range 2>&1":
            alias => "nova-init.sh",
            require => File["nova-init.sh", "/etc/nova/nova.conf"];
    }
}
