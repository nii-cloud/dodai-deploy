define hadoop_cdh4::component::uninstall {
    include hadoop_cdh4::common::uninstall

    package {
        "$title":
            ensure => absent
    }
}
