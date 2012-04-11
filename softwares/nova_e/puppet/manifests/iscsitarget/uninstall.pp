class nova_e::iscsitarget::uninstall {
    package {
        [iscsitarget, iscsitarget-dkms]:
            ensure => purged
    }
}
