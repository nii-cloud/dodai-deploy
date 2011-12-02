class nova::mysql::uninstall {
    include nova::common::uninstall

    file {
        "/tmp/nova/mysql-uninit.sh":
            alias => "mysql-uninit",
            source => "puppet:///modules/nova/mysql-uninit.sh"
    }

    exec {
        "/tmp/nova/mysql-uninit.sh 2>&1":
            alias => "mysql-uninit",
            require => File["mysql-uninit"],
            notify => Exec["remove-tmp-nova"];
    }

    service {
        mysql:
            ensure => stopped,
            require => Exec["mysql-uninit"]
    }

    package {
        mysql-server:
            ensure => purged,
            require => Service[mysql]
    }
}
