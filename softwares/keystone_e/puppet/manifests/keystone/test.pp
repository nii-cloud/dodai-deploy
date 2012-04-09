class keystone_e::keystone::test {
    file {
        "/var/lib/keystone/test.sh":
            alias => "test.sh",
            source => "puppet:///modules/keystone_e/test.sh"
    }

    exec {
        "/var/lib/keystone/test.sh $admin_password 2>&1":
            require => File["test.sh"],
    }
}
