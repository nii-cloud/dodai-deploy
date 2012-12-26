class nova_and_quantum_centos_f::cinder_common::uninstall {
    package {
	[openstack-cinder, python-cinder, python-cinderclient]:
	  ensure => purged
        
    }
}
