class nova::common::install {
    package {
        [python-mysqldb, python-nova, python-eventlet, python-novaclient]:;

        nova-common:
            require => Package[python-novaclient]
    }

    file {
        "/etc/nova/nova.conf":
            content => template("$proposal_id/etc/nova/nova.conf.erb"),
            mode => 644,
            require => Package[nova-common];

        "/tmp/nova":
            ensure => directory,
            mode => 644;

        "/tmp/nova/sudo-init.sh":
            source => "puppet:///modules/nova/sudo-init.sh",
            alias => "sudo-init",
            require => File["/tmp/nova"];
    }

    exec {
        "/tmp/nova/sudo-init.sh 2>&1":
            refreshonly => true,
            subscribe => File["sudo-init"];
    }
}
