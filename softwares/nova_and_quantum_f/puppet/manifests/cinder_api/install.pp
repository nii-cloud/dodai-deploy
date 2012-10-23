class nova_and_quantum_f::cinder_api::install{
    include nova_and_quantum_f::cinder_common::install

    package {
        [cinder-api, python-cinderclient]:
            require => Package[cinder-common];
    }

    exec {
        "stop cinder-api; start cinder-api":
            require => [Package[cinder-api], Exec["db-sync"]];
    }
}
