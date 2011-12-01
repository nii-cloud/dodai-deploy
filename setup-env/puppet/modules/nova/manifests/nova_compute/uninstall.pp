class nova::nova_compute::uninstall {
    include nova::common::uninstall

    package {
        [nova-compute, libvirt-bin]:
            ensure => purged
    }

    file {
        "/tmp/nova/nova-compute-uninit.sh":
            alias => "nova-compute-uninit.sh",
            source => "puppet:///modules/nova/nova-compute-uninit.sh"
    }

    exec {
        "/tmp/nova/nova-compute-uninit.sh 2>&1":
            alias => "nova-compute-uninit.sh",
            require => File["nova-compute-uninit.sh"],
            notify => Exec["remove-tmp-nova"];

        "rm -rf /etc/libvirt/*; exit 0":
            require => Package[libvirt-bin]
    }
}
