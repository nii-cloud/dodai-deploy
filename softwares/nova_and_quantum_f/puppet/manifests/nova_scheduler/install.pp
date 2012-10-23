class nova_and_quantum_f::nova_scheduler::install {
    nova_and_quantum_f::component { "nova-scheduler": }

    exec {
        "stop nova-scheduler; start nova-scheduler":
            require => File["/etc/nova/nova.conf"]
    }
}
