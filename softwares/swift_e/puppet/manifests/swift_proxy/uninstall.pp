class swift_e::swift_proxy::uninstall {
    package {
        [swift, swift-proxy]:
            ensure => purged,
            require => Exec["proxy-uninit"]
    }

    file {
       "/tmp/swift/proxy-uninit.sh":
           source => "puppet:///modules/swift/proxy-uninit.sh"
    }

    exec {
        "/tmp/swift/proxy-uninit.sh":
            alias => "proxy-uninit",
            require => File["/tmp/swift/proxy-uninit.sh"]
    }
}
