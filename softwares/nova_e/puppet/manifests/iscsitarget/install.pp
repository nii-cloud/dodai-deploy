class nova_e::iscsitarget::install {
    package {
        [iscsitarget, iscsitarget-dkms]:
    }

    file {
        "/etc/default/iscsitarget":
            source => "puppet:///modules/nova_e/iscsitarget",
            mode => 644
    }

    service {
        iscsitarget:
            ensure => running,
            require => [File["/etc/default/iscsitarget"], Package[iscsitarget, iscsitarget-dkms]]
    }
}
