class nova_and_quantum_f::cinder_scheduler::install {
    include nova_and_quantum_f::cinder_common::install

    package {
        cinder-scheduler:
            require => Package[cinder-common];
    }

    exec {
        "stop cinder-scheduler; start cinder-scheduler":
            require => [Package[cinder-scheduler], Exec["db-sync"]];
    }
}
