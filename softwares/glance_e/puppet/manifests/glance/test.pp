class glance_e::glance::test {
    file {
        "/var/lib/glance/test.sh":
            alias => "test.sh",
            source => "puppet:///modules/glance/test.sh"
    }

    exec {
        "/var/lib/glance/test.sh 2>&1":
            alias => "test.sh",
            require => File["test.sh"]
    }
}
