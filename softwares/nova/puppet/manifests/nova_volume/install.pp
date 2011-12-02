class nova::nova_volume::install {
    nova::component { "nova-volume": }

    if $is_virtual and $operatingsystem == "Ubuntu" and $operatingsystemrelease == "11.10" {
    } else {
        include nova::iscsitarget::install
    }
}
