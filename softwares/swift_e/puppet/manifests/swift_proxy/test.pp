class swift_e::swift_proxy::test {
    file {
       "/tmp/swift/test.sh":
           source => "puppet:///modules/swift/test.sh"
    }

    exec {
        "/tmp/swift/test.sh $super_admin_key 2>&1":
            require => File["/tmp/swift/test.sh"]
    }

}
