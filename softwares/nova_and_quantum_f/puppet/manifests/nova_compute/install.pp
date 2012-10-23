class nova_and_quantum_f::nova_compute::install {
    nova_and_quantum_f::component { ["nova-compute", vlan]: }

    case $libvirt_type {
        kvm: {include nova_and_quantum_f::kvm::install}
        xen: {include nova_and_quantum_f::xen::install}
        uml: {include nova_and_quantum_f::uml::install}
        lxc: {include nova_and_quantum_f::lxc::install}
    }

    include nova_and_quantum_f::bridge::install
    include nova_and_quantum_f::open_iscsi::install

    include nova_and_quantum_f::linuxbridge_agent::install

    file {
        "/etc/nova/nova-compute.conf":
            content => template("$proposal_id/etc/nova/nova-compute.conf.erb"),
            mode => 644,
            require => Package[nova-compute];

        "/etc/libvirt/qemu.conf":
            content => template("$proposal_id/etc/libvirt/qemu.conf.erb"),
            mode => 644,
            require => Package[nova-compute];
    }

    exec {
        "stop nova-compute; start nova-compute":
            require => File["/etc/nova/nova.conf", "/etc/nova/nova-compute.conf"];

        "stop libvirt-bin; start libvirt-bin":
            require => File["/etc/libvirt/qemu.conf"];
    }

}
