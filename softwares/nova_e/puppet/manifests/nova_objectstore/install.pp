class nova_e::nova_objectstore::install {
    nova_e::component { "nova-objectstore": }

    exec {
        "stop nova-objectstore; start nova-objectstore":
            require => File["/etc/nova/nova.conf"]
    }
}
