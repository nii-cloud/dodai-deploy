define nova_and_quantum_f::component() {
    include nova_and_quantum_f::common::install

    package {
        $title:
            require => Package[python-nova],
            notify => File["/etc/nova/nova.conf"]
    }
}
