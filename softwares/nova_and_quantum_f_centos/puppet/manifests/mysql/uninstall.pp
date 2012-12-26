class nova_and_quantum_centos_f::mysql::uninstall {
    file {
        "/var/lib/mysql/mysql-uninit.sh":
            alias => "mysql-uninit",
            source => "puppet:///modules/nova_and_quantum_centos_f/mysql-uninit.sh"
    }

    exec {
        "/var/lib/mysql/mysql-uninit.sh 2>&1":
            alias => "mysql-uninit",
            require => File["mysql-uninit"]
    }

}

