class nova_e::uml::uninstall {
    package {
        nova-compute-uml: 
            ensure => purged
    }
}
