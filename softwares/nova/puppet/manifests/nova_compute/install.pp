class nova::nova_compute::install {
    nova::component { ["nova-compute", vlan]: }

    case $libvirt_type {
        kvm: {include nova::kvm}
        xen: {include nova::xen}
        uml: {include nova::uml}
        lxc: {include nova::lxc}
    }

    include nova::bridge

    file {
        "/etc/nova/nova-compute.conf":
            content => template("$proposal_id/etc/nova/nova-compute.conf.erb"),
            mode => 644,
            require => Package[nova-compute];
    }
}
