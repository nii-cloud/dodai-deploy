class nova_and_quantum_centos_f::quantum::uninstall {
    package {
	[openstack-quantum, openstack-quantum-linuxbridge, python-quantum]:
            ensure => purged
    }

    exec {
        "rm -rf /var/lib/quantum/*":
            require => Package[openstack-quantum, openstack-quantum-linuxbridge, python-quantum];
    }
}
