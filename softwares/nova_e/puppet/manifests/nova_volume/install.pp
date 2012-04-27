class nova_e::nova_volume::install {
    nova_e::component { "nova-volume": }

    exec {
        "stop nova-volume; start nova-volume":
            require => File["/etc/nova/nova.conf"]
    }

    include nova_e::tgt::install
}
