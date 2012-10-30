class eucalyptus::cluster_controller::uninstall {
    include eucalyptus::common::uninstall
    package {
        [eucalyptus-cc, eucalyptus-sc]:
            ensure => purged;
    }
}
