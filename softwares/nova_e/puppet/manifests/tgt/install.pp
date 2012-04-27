class nova_e::tgt::install {
    package {
        tgt:
    }

    service {
        tgt:
            ensure => running,
            require => Package[tgt] 
    }
}
