class nova_e::nova_volume::install {
    nova_e::component { "nova-volume": }

    exec {
        "stop nova-volume; start nova-volume":
            require => File["/etc/nova/nova.conf"]
    }

    if $is_virtual and $operatingsystem == "Ubuntu" {
    } else {
        include nova_e::iscsitarget::install
    }
}
