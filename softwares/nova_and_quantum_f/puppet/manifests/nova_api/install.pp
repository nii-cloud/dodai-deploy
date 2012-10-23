class nova_and_quantum_f::nova_api::install {
    nova_and_quantum_f::component {
        ["nova-api", "python-libvirt", euca2ools, unzip, gawk, "python-keystone"]:
    }

    file {
        "/var/lib/nova/nova-init.sh":
            source => "puppet:///modules/nova_and_quantum_f/nova-init.sh",
            alias => "nova-init.sh", 
            require => Package[nova-common];
    }

    exec {
        "stop nova-api; start nova-api":
            require => Exec["nova-init.sh"];

        "/var/lib/nova/nova-init.sh 2>&1":
            alias => "nova-init.sh",
            require => File["nova-init.sh", "/etc/nova/nova.conf"];
    }
}
