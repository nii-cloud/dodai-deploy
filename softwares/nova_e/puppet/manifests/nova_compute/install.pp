class nova_e::nova_compute::install {
    nova_e::component { ["nova-compute", vlan]: }

    case $libvirt_type {
        kvm: {include nova_e::kvm::install}
        xen: {include nova_e::xen::install}
        uml: {include nova_e::uml::install}
        lxc: {include nova_e::lxc::install}
    }

    include nova_e::bridge::install
    include nova_e::open_iscsi::install

    file {
        "/etc/nova/nova-compute.conf":
            content => template("$proposal_id/etc/nova/nova-compute.conf.erb"),
            mode => 644,
            require => Package[nova-compute];
    }

    exec {
        "stop nova-compute; start nova-compute":
            require => File["/etc/nova/nova.conf", "/etc/nova/nova-compute.conf"]
    }
}
