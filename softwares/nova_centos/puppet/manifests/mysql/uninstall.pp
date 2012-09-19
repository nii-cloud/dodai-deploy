class nova_centos::mysql::uninstall {
    include nova_centos::common::uninstall

    file {
        "/var/lib/mysql/mysql-uninit.sh":
            alias => "mysql-uninit",
            source => "puppet:///modules/nova_centos/mysql-uninit.sh"
    }

    exec {
        "/var/lib/mysql/mysql-uninit.sh 2>&1":
            alias => "mysql-uninit",
            require => File["mysql-uninit"];

        "rm -rf /var/lib/mysql/*":
            require => Package[mysql, mysql-server];
    }

    service {
        mysqld:
            ensure => stopped,
            require => Exec["mysql-uninit"]
    }

    package {
        [mysql, mysql-server]:
            ensure => purged,
            require => Service[mysqld]
    }
}
