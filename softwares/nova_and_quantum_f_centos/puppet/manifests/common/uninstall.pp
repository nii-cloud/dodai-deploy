class nova_and_quantum_f_centos::common::uninstall {
    package {
	   [openstack-nova, openstack-nova-doc, python-nova, python-nova-adminclient, python-novaclient, python-novaclient-doc, qpid-cpp-server]:
             ensure => purged
    }

    exec {
        "rm -rf /var/lib/nova/*; rm -rf /var/log/nova/*; rm -rf /etc/nova/*":
           require => Package[openstack-nova, openstack-nova-doc, python-nova, python-nova-adminclient, python-novaclient, python-novaclient-doc, qpid-cpp-server];
   }
}
