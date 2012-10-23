class nova_and_quantum_f::common::add_source_list {
    include apt
    apt::key {
        "EC4926EA":
            keyserver => "keyserver.ubuntu.com",
    }

    apt::sources_list {
        folsom:
            ensure  => present,
            content => 'deb http://ubuntu-cloud.archive.canonical.com/ubuntu precise-updates/folsom main',
    }
}
