class nova_and_quantum_f_centos::nova_console::install {
     include nova_and_quantum_f_centos::common::install

     service {
        openstack-nova-console:
            ensure => running,
            require => File["/etc/nova/nova.conf"];
	
	openstack-nova-consoleauth:
            ensure => running,
            require => File["/etc/nova/nova.conf"];
     }
}
