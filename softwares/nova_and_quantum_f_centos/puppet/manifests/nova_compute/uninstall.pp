class nova_and_quantum_f_centos::nova_compute::uninstall {
    include nova_and_quantum_f_centos::common::uninstall
    
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
