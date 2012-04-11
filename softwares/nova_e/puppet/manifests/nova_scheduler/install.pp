class nova_e::nova_scheduler::install {
    nova_e::component { "nova-scheduler": }

    exec {
        "stop nova-scheduler; start nova-scheduler":
            require => File["/etc/nova/nova.conf"]
    }
}
