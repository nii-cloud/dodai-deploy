define nova_e::component() {
    include nova_e::common::install

    package {
        $title:
            require => Package[python-nova],
            notify => File["/etc/nova/nova.conf"]
    }
}
