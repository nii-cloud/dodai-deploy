class nova_e::nova_compute::uninstall {
    include nova_e::common::uninstall
    include nova_e::bridge::uninstall
    include nova_e::open_iscsi::uninstall

    case $libvirt_type {
        kvm: {include nova_e::kvm::uninstall}
        xen: {include nova_e::xen::uninstall}
        uml: {include nova_e::uml::uninstall}
        lxc: {include nova_e::lxc::uninstall}
    }

    package {
        [nova-compute, libvirt-bin]:
            ensure => purged
    }

    file {
        "/var/lib/nova/nova-compute-uninit.sh":
            alias => "nova-compute-uninit.sh",
            source => "puppet:///modules/nova_e/nova-compute-uninit.sh"
    }

    exec {
        "/var/lib/nova/nova-compute-uninit.sh 2>&1":
            alias => "nova-compute-uninit.sh",
            require => File["nova-compute-uninit.sh"];

        "rm -rf /etc/libvirt/*; exit 0":
            require => Package[libvirt-bin]
    }
}
