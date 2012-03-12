class nova::nova_volume::install {
    nova::component { "nova-volume": }

    exec {
        "stop nova-volume; start nova-volume":
            require => File["/etc/nova/nova.conf"]
    }

    if $is_virtual and $operatingsystem == "Ubuntu" and $operatingsystemrelease == "11.10" {
    } else {
        include nova::iscsitarget::install
    }
}
