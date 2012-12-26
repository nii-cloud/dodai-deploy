class nova_and_quantum_f_centos::cinder_scheduler::install{
    include nova_and_quantum_f_centos::cinder_common::install

    exec {
        "service openstack-cinder-scheduler start":
            require => Exec["db-sync"];
    }
}
