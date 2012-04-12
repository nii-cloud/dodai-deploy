class swift_e::common {
    user {
        swift:
            ensure => present
    }

    file {
        "/etc/swift":
            ensure => directory,
            mode => 644,
            owner => swift,
            group => swift,
            require => User[swift];

        "/etc/swift/cert.crt":
            source => "puppet:///modules/swift/cert.crt",
            mode => 644,
            require => File["/etc/swift"];

        "/etc/swift/cert.key":
            source => "puppet:///modules/swift/cert.key",
            mode => 644,
            require => File["/etc/swift"];

        "/etc/swift/swift.conf":
            content => template("$proposal_id/etc/swift/swift.conf.erb"),
            mode => 644,
            owner => swift,
            group => swift,
            require => [File["/etc/swift"]];

        "/tmp/swift":
            ensure => directory,
            mode => 644
    }
}
