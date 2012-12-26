class nova_and_quantum_centos_f::nova_compute::install {
    include nova_and_quantum_centos_f::common::install

    file{
        "/etc/libvirt/qemu.conf":
            content => template("$proposal_id/etc/libvirt/qemu.conf.erb"),
            mode => 644,
            require => Package[openstack-nova];

        "/etc/nova/nova-compute.conf":
            content => template("$proposal_id/etc/nova/nova-compute.conf.erb"),
            mode => 644,
            require => Package[openstack-nova];
    }
    
    service {
        openstack-nova-compute:
            ensure => running,
            require => File["/etc/nova/nova.conf", "/etc/nova/nova-compute.conf"];
    }

    exec{
        "/etc/init.d/libvirtd restart":
            require => File["/etc/libvirt/qemu.conf"];
    }
}
