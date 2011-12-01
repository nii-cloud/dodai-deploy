class nova::iscsitarget::install {
    package {
        [iscsitarget, iscsitarget-dkms]:
    }

    file {
        "/etc/default/iscsitarget":
            source => "puppet:///modules/nova/iscsitarget",
            mode => 644,
            require => Package[nova-volume]
    }

    service {
        iscsitarget:
            ensure => running,
            require => [File["/etc/default/iscsitarget"], Package[iscsitarget, iscsitarget-dkms]]
    }
}
