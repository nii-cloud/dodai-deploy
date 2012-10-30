class eucalyptus::common::uninstall {
    package {
        [eucalyptus-common, eucalyptus-java-common, eucalyptus-admin-tools, eucalyptus-gl, euca2ools]:
            ensure => purged
    }

    exec {
        "rm -rf {/etc,/usr/share,/var/log,/var/lib}/eucalyptus/*":
            require => Package[eucalyptus-common, eucalyptus-java-common, eucalyptus-admin-tools, eucalyptus-gl, euca2ools];
    }
}
