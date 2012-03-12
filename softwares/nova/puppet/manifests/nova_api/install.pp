class nova::nova_api::install {
    nova::component {
        ["nova-api", "python-libvirt", euca2ools, unzip, gawk]:
    }

    exec {
        "stop nova-api; start nova-api":
            require => File["/etc/nova/nova.conf"]
    }
}
