class nova_and_quantum_f::nova_volume::install {
    nova_and_quantum_f::component { "nova-volume": }

    exec {
        "stop nova-volume; start nova-volume":
            require => File["/etc/nova/nova.conf"]
    }

    include nova_and_quantum_f::tgt::install
}
