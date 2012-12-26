class nova_and_quantum_centos_f::cinder_scheduler::install{
    include nova_and_quantum_centos_f::cinder_common::install

    exec {
        "service openstack-cinder-scheduler start":
            require => Exec["db-sync"];
    }
}
