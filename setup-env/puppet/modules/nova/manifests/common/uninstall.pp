class nova::common::uninstall {
    exec {
        "rm -rf /tmp/nova":
            alias => "remove-tmp-nova";

        "/tmp/nova/sudo-uninit.sh":
            refreshonly => true,
            notify => Exec["remove-tmp-nova"],
            subscribe => File["sudo-uninit"]
    }

    package {
        [python-nova, nova-common]:
           ensure => purged
    }

    file {
        "/tmp/nova/sudo-uninit.sh":
            source => "puppet:///modules/nova/sudo-uninit.sh",
            alias => "sudo-uninit"
    }
}
