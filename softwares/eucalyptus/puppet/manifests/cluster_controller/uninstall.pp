class eucalyptus::cluster_controller::uninstall {
    include eucalyptus::common::uninstall
    package {
        [eucalyptus-cc, eucalyptus-sc]:
            ensure => purged;
    }

    exec {
        "rm -rf {/etc,/usr/share,/var/log,/var/lib}/eucalyptus/*":
            require => Package[eucalyptus-cc, eucalyptus-sc];
    }
}
