class nova_centos::mysql::install {
    file {
        "/var/lib/mysql-init.sh":
            alias => "mysql-init.sh",
            source => "puppet:///modules/nova_centos/mysql-init.sh";
    }

    exec {
        "/var/lib/mysql-init.sh 2>&1":
            alias => "mysql-init.sh",
            require => [File["mysql-init.sh"], Service[mysqld]]
    }

    package {
        [mysql, mysql-server, MySQL-python]:
    }

    service {
        mysqld:
            ensure => running,
            require => Package[mysql, mysql-server, MySQL-python];
    }
}
