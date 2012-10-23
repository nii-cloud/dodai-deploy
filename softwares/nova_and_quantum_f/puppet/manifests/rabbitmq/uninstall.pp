class nova_and_quantum_f::rabbitmq::uninstall {
    service {
        rabbitmq-server:
            ensure => stopped;
    }

    package {
        rabbitmq-server:
            ensure => purged,
            require => Service[rabbitmq-server];
    }
}
