class nova_and_quantum_centos_f::nova_compute::uninstall {
    include nova_and_quantum_centos_f::common::uninstall
    
    package {
        libvirt:
          ensure => purged,
          require =>Package[openstack-nova];
    }
 
    exec {
        "rm -rf /etc/libvirt/*; exit 0":
            require => Package[libvirt]
    }
}
