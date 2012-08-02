class eucalyptus::common::uninstall {
    package {
        [eucalyptus-common, eucalyptus-java-common, eucalyptus-admin-tools, eucalyptus-gl, euca2ools]:
            ensure => purged
    }
}
