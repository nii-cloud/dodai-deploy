class nova_and_quantum_f_centos::cinder_common::uninstall {
    package {
	[openstack-cinder, python-cinder, python-cinderclient]:
	  ensure => purged
        
    }
}
