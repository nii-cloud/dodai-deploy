define nova::component() {
    include nova::common::install

    package {
        $title:
            require => Package[python-nova],
            notify => File["/etc/nova/nova.conf"]
    }
}
