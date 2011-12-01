class nova::nova_volume::uninstall {
    include nova::common::uninstall

    package {
        nova-volume:
            ensure => purged
    }

    if $is_virtual and $operatingsystem == "Ubuntu" and $operatingsystemrelease == "11.10" {
    } else {
        include nova::iscsitarget::uninstall
    }
}
