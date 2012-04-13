class glance_e::glance::test {
    file {
        "/var/lib/glance/test.sh":
            alias => "test.sh",
            content => template("glance_e/test.sh.erb")
    }

    exec {
        "/var/lib/glance/test.sh 2>&1":
            alias => "test.sh",
            require => File["test.sh"]
    }
}
