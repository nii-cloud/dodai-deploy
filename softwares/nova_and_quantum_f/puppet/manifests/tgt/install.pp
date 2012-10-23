class nova_and_quantum_f::tgt::install {
    package {
        tgt:
    }

    service {
        tgt:
            ensure => running,
            require => Package[tgt] 
    }
}
