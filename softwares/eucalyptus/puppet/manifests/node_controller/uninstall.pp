class eucalyptus::node_controller::uninstall {
    include eucalyptus::common::uninstall
    package {
        eucalyptus-nc:
            ensure => purged,
            require => Exec["/tmp/nc-uninit.sh"];
    }

    file {
        "/tmp/nc-uninit.sh":
            alias => "nc-uninit.sh",
            source => "puppet:///modules/eucalyptus/nc-uninit.sh";
    }

    exec {
        "/tmp/nc-uninit.sh":
            require => File["nc-uninit.sh"];

        "rm -rf {/etc,/usr/share,/var/log,/var/lib}/eucalyptus/*":
            require => Package[eucalyptus-nc];
    }
}
