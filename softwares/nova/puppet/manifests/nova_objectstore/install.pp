class nova::nova_objectstore::install {
    nova::component { "nova-objectstore": }

    exec {
        "stop nova-objectstore; start nova-objectstore":
            require => File["/etc/nova/nova.conf"]
    }
}
