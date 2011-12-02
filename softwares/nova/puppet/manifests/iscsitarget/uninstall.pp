class nova::iscsitarget::uninstall {
    package {
        [iscsitarget, iscsitarget-dkms]:
            ensure => purged
    }
}
