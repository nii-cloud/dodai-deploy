class nova_and_quantum_centos_f::nova_console::install {
     include nova_and_quantum_centos_f::common::install

     service {
        openstack-nova-console:
            ensure => running,
            require => File["/etc/nova/nova.conf"];
	
	openstack-nova-consoleauth:
            ensure => running,
            require => File["/etc/nova/nova.conf"];
     }
}
