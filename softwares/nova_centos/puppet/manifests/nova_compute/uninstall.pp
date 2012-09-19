class nova_centos::nova_compute::uninstall {
    include nova_centos::common::uninstall
    include nova_centos::bridge::uninstall
    include nova_centos::open_iscsi::uninstall

    package {
        libvirt:
            ensure => purged,
            require => Exec["nova-compute-uninit.sh"];
    }

    file {
        "/tmp/nova-compute-uninit.sh":
            alias => "nova-compute-uninit.sh",
            source => "puppet:///modules/nova_centos/nova-compute-uninit.sh"
    }

    exec {
        "/tmp/nova-compute-uninit.sh 2>&1":
            alias => "nova-compute-uninit.sh",
            before => Package[iscsi-initiator-utils],
            require => File["nova-compute-uninit.sh"];

        "rm -rf /etc/libvirt/*; exit 0":
            require => Package[libvirt]
    }
}
