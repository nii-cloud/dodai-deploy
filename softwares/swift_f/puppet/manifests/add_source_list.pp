class swift_f::add_source_list {
    include apt
    apt::key {
        "EC4926EA":
            keyserver => "keyserver.ubuntu.com",
            alias => folsom
    }

    apt::sources_list {
        folsom:
            ensure  => present,
            content => 'deb http://ubuntu-cloud.archive.canonical.com/ubuntu precise-updates/folsom main',
    }
}
