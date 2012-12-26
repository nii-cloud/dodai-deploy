class nova_and_quantum_centos_f::rabbitmq::uninstall {
    service {
        rabbitmq-server:
            ensure => stopped;
    }

    package {
        rabbitmq-server:
            ensure => purged,
            require => Service[rabbitmq-server];
    }

    exec {
        "killall epmd; exit 0":
            require => Package[rabbitmq-server];
    }
}
