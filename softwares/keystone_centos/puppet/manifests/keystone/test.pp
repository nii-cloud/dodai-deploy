class keystone_centos::keystone::test {
    file {
        "/var/lib/keystone/test.sh":
            alias => "test.sh",
            content => template("keystone_centos/test.sh.erb")
    }

    exec {
        "/var/lib/keystone/test.sh 2>&1":
            require => File["test.sh"],
    }
}
