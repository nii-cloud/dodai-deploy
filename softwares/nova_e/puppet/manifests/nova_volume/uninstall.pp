class nova_e::nova_volume::uninstall {
    include nova_e::common::uninstall

    package {
        nova-volume:
            ensure => purged
    }

    if $is_virtual and $operatingsystem == "Ubuntu" and $operatingsystemrelease == "11.10" {
    } else {
        include nova_e::iscsitarget::uninstall
    }
}
