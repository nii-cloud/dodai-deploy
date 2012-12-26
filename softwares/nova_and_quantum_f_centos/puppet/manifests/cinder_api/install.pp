class nova_and_quantum_centos_f::cinder_api::install{
    include nova_and_quantum_centos_f::cinder_common::install

    exec {
        "service openstack-cinder-api start":
            require => Exec["db-sync"];
    }
}
