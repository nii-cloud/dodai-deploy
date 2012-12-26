class glance_f_centos::mysql::install {

    package {
        [mysql, mysql-server, MySQL-python]:
    }

    service {
        mysqld:
            ensure => running,
            require => Package[mysql, mysql-server, MySQL-python];
    }

     file {
        "/var/lib/mysql-init.sh":
            alias => "mysql-init.sh",
            source => "puppet:///modules/keystone_f_centos/mysql-init.sh";
    }

    exec {
        "/var/lib/mysql-init.sh 2>&1":
            alias => "mysql-init.sh",
            require => [File["mysql-init.sh"], Service[mysqld]]
    }
  
}
