class nova_e::mysql::install {
    file {
        "/var/lib/mysql-preseed.sh":
            alias => "mysql-preseed.sh",
            source => "puppet:///modules/nova_e/mysql-preseed.sh";
        "/var/lib/mysql-init.sh":
            alias => "mysql-init.sh",
            source => "puppet:///modules/nova_e/mysql-init.sh";
    }

    exec {
        "/var/lib/mysql-preseed.sh 2>&1":
            alias => "mysql-preseed.sh",
            require => File["mysql-preseed.sh"];
        "/var/lib/mysql-init.sh 2>&1":
            alias => "mysql-init.sh",
            require => [Package[mysql-server], File["mysql-init.sh"], Service[mysql]]
    }

    package {
        mysql-server:
            require => Exec["mysql-preseed.sh"],
            notify => [Service[mysql]]
    }

    service {
        mysql:
            ensure => running
    }
}
