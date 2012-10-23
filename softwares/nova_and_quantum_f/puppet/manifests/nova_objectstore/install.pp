class nova_and_quantum_f::nova_objectstore::install {
    nova_and_quantum_f::component { "nova-objectstore": }

    exec {
        "stop nova-objectstore; start nova-objectstore":
            require => File["/etc/nova/nova.conf"]
    }
}
