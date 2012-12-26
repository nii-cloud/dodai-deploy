class nova_and_quantum_f_centos::cinder_api::install{
    include nova_and_quantum_f_centos::cinder_common::install

    exec {
        "service openstack-cinder-api start":
            require => Exec["db-sync"];
    }
}
