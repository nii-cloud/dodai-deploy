class nova_and_quantum_centos_f::rabbitmq::install {
    package { rabbitmq-server: }

    service {
        qpidd:
            ensure => stopped;

        rabbitmq-server:
            ensure => running,
            require => [Package[rabbitmq-server], Service[qpidd]];
    }
}
