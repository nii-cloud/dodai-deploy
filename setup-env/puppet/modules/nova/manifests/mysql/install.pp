class nova::mysql::install {
    include nova::common::install

    file {
        "/tmp/nova/mysql-preseed.sh":
            alias => "mysql-preseed.sh",
            source => "puppet:///modules/nova/mysql-preseed.sh",
            require => File["/tmp/nova"];
        "/tmp/nova/mysql-init.sh":
            alias => "mysql-init.sh",
            source => "puppet:///modules/nova/mysql-init.sh",
            require => File["/tmp/nova"];
    }

    exec {
        "/tmp/nova/mysql-preseed.sh 2>&1":
            alias => "mysql-preseed.sh",
            require => File["mysql-preseed.sh"];
        "/tmp/nova/mysql-init.sh $network_ip_range 2>&1":
            alias => "mysql-init.sh",
            require => [Package[mysql-server, nova-common], File["mysql-init.sh", "/etc/nova/nova.conf"], Service[mysql]]
    }

    package {
        mysql-server:
            require => Exec["mysql-preseed.sh"],
            notify => [Service[mysql], File["/etc/nova/nova.conf"]]
    }

    service {
        mysql:
            ensure => running
    }
}
