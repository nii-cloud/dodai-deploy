class nova_and_quantum_f::mysql::uninstall {
    include nova_and_quantum_f::common::uninstall

    file {
        "/var/lib/mysql/mysql-uninit.sh":
            alias => "mysql-uninit",
            source => "puppet:///modules/nova_and_quantum_f/mysql-uninit.sh"
    }

    exec {
        "/var/lib/mysql/mysql-uninit.sh 2>&1":
            alias => "mysql-uninit",
            require => File["mysql-uninit"]
    }

    service {
        mysql:
            ensure => stopped,
            require => Exec["mysql-uninit"]
    }

    package {
        [mysql-server, mysql-common]:
            ensure => purged,
            require => Service[mysql]
    }
}
