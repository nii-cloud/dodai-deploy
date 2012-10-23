class nova_and_quantum_f::cinder_volume::uninstall {
    include nova_and_quantum_f::cinder_common::uninstall

    package {
        [cinder-volume, tgt]:
            ensure => purged;
    }

    file {
        "/var/lib/cinder/cinder-uninit.sh":
            source => "puppet:///modules/nova_and_quantum_f/cinder-uninit.sh",
            require => Package[cinder-volume];
    }

    exec {
        "/var/lib/cinder/cinder-uninit.sh 2>&1":
            alias => "cinder-uninit.sh",
            require => File["/var/lib/cinder/cinder-uninit.sh"];

        "rm -rf /var/lib/cinder/*":
            require => Exec["cinder-uninit.sh"];
    }
}
