class nova::nova_scheduler::install {
    nova::component { "nova-scheduler": }

    exec {
        "stop nova-scheduler; start nova-scheduler":
            require => File["/etc/nova/nova.conf"]
    }
}
