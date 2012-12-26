class nova_and_quantum_f_centos::common::install {
    package {
	 openstack-nova:
	    require => Package[openstack-utils,memcached,qpid-cpp-server];

	 [openstack-utils,memcached,qpid-cpp-server]:

    }

    file {
        "/etc/nova/nova.conf":
            content => template("$proposal_id/etc/nova/nova.conf.erb"),
            mode => 644,
            require => Package[openstack-nova];
    }
}
