class nova_and_quantum_f::nova_compute::uninstall {
    include nova_and_quantum_f::common::uninstall
    include nova_and_quantum_f::bridge::uninstall
    include nova_and_quantum_f::open_iscsi::uninstall

    case $libvirt_type {
        kvm: {include nova_and_quantum_f::kvm::uninstall}
        xen: {include nova_and_quantum_f::xen::uninstall}
        uml: {include nova_and_quantum_f::uml::uninstall}
        lxc: {include nova_and_quantum_f::lxc::uninstall}
    }

    package {
        [nova-compute, libvirt-bin]:
            ensure => purged
    }

    include nova_and_quantum_f::linuxbridge_agent::uninstall

    file {
        "/var/lib/nova/nova-compute-uninit.sh":
            alias => "nova-compute-uninit.sh",
            source => "puppet:///modules/nova_and_quantum_f/nova-compute-uninit.sh"
    }

    exec {
        "/var/lib/nova/nova-compute-uninit.sh 2>&1":
            alias => "nova-compute-uninit.sh",
            require => File["nova-compute-uninit.sh"],
            before => Package[libvirt-bin, bridge-utils, open-iscsi];

        "rm -rf /etc/libvirt/*; exit 0":
            require => Package[libvirt-bin]
    }
}
